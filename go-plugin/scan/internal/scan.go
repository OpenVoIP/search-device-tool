package internal

import (
	"context"
	"fmt"
	"net"
	"os"
	"scan/utils"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/google/gopacket/pcap"
	log "github.com/sirupsen/logrus"

	manuf "github.com/timest/gomanuf"
)

// ipNet 存放 IP地址和子网掩码

var ipNet *net.IPNet

// 本机的mac地址，发以太网包需要用到
var localHaddr net.HardwareAddr

var iface string

// 存放最终的数据，key[string] 存放的是IP地址
var deviceInfos map[string]Info

// 计时器，在一段时间没有新的数据写入data中，退出程序，反之重置计时器
var t *time.Ticker
var do chan string

const (
	//START 开始 3秒的计时器
	START = "start"
	//END 结束
	END = "end"
)

//Info 扫描到的信息
type Info struct {
	// IP地址
	Mac net.HardwareAddr
	// 主机名
	Hostname string
	// 厂商信息
	Manuf string
}

//PrintData 格式化输出结果
// xxx.xxx.xxx.xxx  xx:xx:xx:xx:xx:xx  hostname  manuf
// xxx.xxx.xxx.xxx  xx:xx:xx:xx:xx:xx  hostname  manuf
func PrintData(deviceInfos map[string]Info) {
	var keys IPSlice
	for k := range deviceInfos {
		keys = append(keys, ParseIPString(k))
	}
	sort.Sort(keys)
	for _, k := range keys {
		d := deviceInfos[k.String()]
		mac := ""
		if d.Mac != nil {
			mac = d.Mac.String()
		}
		fmt.Printf("%-15s %-17s %-30s %-10s\n", k.String(), mac, d.Hostname, d.Manuf)
	}
}

//pushData 将抓到的数据集加入到data中，同时重置计时器
func pushData(ip string, mac net.HardwareAddr, hostname, manuf string) {
	// 停止计时器
	do <- START
	var mu sync.RWMutex
	mu.RLock()
	defer func() {
		// 重置计时器
		do <- END
		mu.RUnlock()
	}()
	if _, ok := deviceInfos[ip]; !ok {
		deviceInfos[ip] = Info{Mac: mac, Hostname: hostname, Manuf: manuf}
		return
	}
	info := deviceInfos[ip]
	if len(hostname) > 0 && len(info.Hostname) == 0 {
		info.Hostname = hostname
	}
	if len(manuf) > 0 && len(info.Manuf) == 0 {
		info.Manuf = manuf
	}
	if mac != nil {
		info.Mac = mac
	}
	deviceInfos[ip] = info
}

func setupNetInfo(f string) {
	var ifs []net.Interface
	var err error
	if f == "" {
		ifs, err = net.Interfaces()
	} else {
		// 已经选择iface
		var it *net.Interface
		it, err = net.InterfaceByName(f)
		if err == nil {
			ifs = append(ifs, *it)
		}
	}
	if err != nil {
		log.Errorf("无法获取本地网络信息:", err)
		return
	}
	for _, it := range ifs {
		addr, _ := it.Addrs()
		for _, a := range addr {
			if ip, ok := a.(*net.IPNet); ok && !ip.IP.IsLoopback() {
				if ip.IP.To4() != nil && strings.HasPrefix(ip.IP.To4().String(), "192.168") {
					ipNet = ip
					localHaddr = it.HardwareAddr
					iface = it.Name
					goto END
				}
			}
		}
	}

	// iface 重置
	if utils.IsWindows() {
		devices, err := pcap.FindAllDevs()
		if err != nil {
			log.Error(err)
			return
		}
		for _, device := range devices {
			for _, address := range device.Addresses {
				if strings.Contains(ipNet.IP.To4().String(), address.IP.String()) {
					iface = device.Name
					break
				}
			}
		}
	}
END:
	if ipNet == nil || len(localHaddr) == 0 {
		log.Error("无法获取本地网络信息")
	}
}

func localHost() {
	host, _ := os.Hostname()
	deviceInfos[ipNet.IP.String()] = Info{Mac: localHaddr, Hostname: strings.TrimSuffix(host, ".local"), Manuf: manuf.Search(localHaddr.String())}
}

func sendARP() {
	// ips 是内网IP地址集合
	ips := Table(ipNet)
	for _, ip := range ips {
		go sendArpPackage(ip)
	}
}

//Scan 扫描
func Scan(interfaceName string, printData func(map[string]Info)) {

	iface = interfaceName

	// 初始化 data
	deviceInfos = make(map[string]Info)
	do = make(chan string)

	// 初始化 网络信息
	setupNetInfo(iface)

	ctx, cancel := context.WithCancel(context.Background())
	go listenARP(ctx)
	go listenMDNS(ctx)
	go listenNBNS(ctx)
	go sendARP()
	go localHost()

	t = time.NewTicker(4 * time.Second)
	for {
		select {
		case <-t.C:
			if printData != nil {
				printData(deviceInfos)
			} else {
				PrintData(deviceInfos)
			}
			cancel()
			goto END
		case d := <-do:
			switch d {
			case START:
				t.Stop()
			case END:
				// 接收到新数据，重置2秒的计数器
				t = time.NewTicker(2 * time.Second)
			}
		}
	}
END:
}
