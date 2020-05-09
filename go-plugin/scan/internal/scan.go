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

	"scan/manuf"
)

// ipNet 存放 IP地址和子网掩码
var ipNet *net.IPNet

// 本机的mac地址，发以太网包需要用到
var localHaddr net.HardwareAddr

// 指定网卡
var iface string

//infos 存放最终的数据，key[string] 存放的是IP地址
var infos sync.Map

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

	// Model
	Model string
}

//PrintData 格式化输出结果
// xxx.xxx.xxx.xxx  xx:xx:xx:xx:xx:xx  hostname  manuf
// xxx.xxx.xxx.xxx  xx:xx:xx:xx:xx:xx  hostname  manuf
func PrintData(deviceInfos *sync.Map) {
	var keys IPSlice
	deviceInfos.Range(func(k, v interface{}) bool {
		keys = append(keys, ParseIPString(k.(string)))
		sort.Sort(keys)
		return true
	})
	for _, key := range keys {
		d, _ := deviceInfos.Load(key.String())
		mac := ""
		if d.(Info).Mac != nil {
			mac = d.(Info).Mac.String()
		}
		fmt.Printf("%-15s %-17s %-30s %-10s\n", key.String(), mac, d.(Info).Hostname, d.(Info).Manuf)
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
	if _, ok := infos.Load(ip); !ok {
		infos.Store(ip, Info{
			Mac:      mac,
			Hostname: hostname,
			Manuf:    manuf,
			Model:    utils.GetModel(mac.String()),
		})
		return
	}
	v, _ := infos.Load(ip)
	info := v.(Info)
	if len(hostname) > 0 && len(info.Hostname) == 0 {
		info.Hostname = hostname
	}
	if len(manuf) > 0 && len(info.Manuf) == 0 {
		info.Manuf = manuf
	}
	if mac != nil {
		info.Mac = mac
	}

	infos.Store(ip, info)
}

// 获取指定网卡信息
func setupNetInfo(faceName string) {
	var ifs []net.Interface
	var err error

	// 若已经选择网卡使用指定网卡，否则从多个网卡选择一个合适网卡
	if faceName == "" {
		ifs, err = net.Interfaces()
	} else {
		var it *net.Interface
		it, err = net.InterfaceByName(faceName)
		if err == nil {
			ifs = append(ifs, *it)
		}
	}
	if err != nil {
		log.Errorf("无法获取本地网络信息: %+v", err)
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

END:
	if ipNet == nil || len(localHaddr) == 0 {
		log.Error("无法获取本地网络信息")
	}

	// iface Name 重置
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
}

func localHost() {
	host, _ := os.Hostname()
	infos.Store(
		ipNet.IP.String(),
		Info{Mac: localHaddr, Hostname: strings.TrimSuffix(host, ".local"), Manuf: manuf.Search(localHaddr.String())})
}

func sendARP() {
	// ips 是内网IP地址集合
	ips := Table(ipNet)
	for _, ip := range ips {
		go sendArpPackage(ip)
	}
}

//Scan 扫描
func Scan(interfaceName string, callback func(*sync.Map)) {
	iface = interfaceName

	// 初始化 data
	do = make(chan string)
	infos.Range(func(key interface{}, value interface{}) bool {
		infos.Delete(key)
		return true
	})

	// 初始化 网络信息
	setupNetInfo(iface)

	// 开始查询
	ctx, cancel := context.WithCancel(context.Background())
	go listenARP(ctx)
	go listenMDNS(ctx)
	go listenNBNS(ctx)
	go sendARP()
	go localHost()

	t = time.NewTicker(10 * time.Second)
	for {
		select {
		case <-t.C:
			if callback != nil {
				callback(&infos)
			} else {
				PrintData(&infos)
			}
			cancel()
			goto END
		case d := <-do:
			switch d {
			case START:
				t.Stop()
			case END:
				// 接收到新数据，重置6秒的计数器
				t = time.NewTicker(6 * time.Second)
			}
		}
	}
END:
}
