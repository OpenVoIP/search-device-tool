package internal

import (
	"context"
	"net"
	"strings"
	"time"

	"scan/manuf"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
	log "github.com/sirupsen/logrus"
)

func listenARP(ctx context.Context, iface iface) {
	// log.Infof("pcap open live: %s", iface.name)
	handle, err := pcap.OpenLive(iface.name, 1024, false, 10*time.Second)
	if err != nil {
		log.Errorf("pcap打开失败: %+v", err)
		return
	}
	defer handle.Close()
	handle.SetBPFFilter("arp")
	ps := gopacket.NewPacketSource(handle, handle.LinkType())
	for {
		select {
		case <-ctx.Done():
			return
		case p := <-ps.Packets():
			arp := p.Layer(layers.LayerTypeARP).(*layers.ARP)
			if arp.Operation == 2 {
				mac := net.HardwareAddr(arp.SourceHwAddress)
				m := manuf.Search(mac.String())
				ip := ParseIP(arp.SourceProtAddress).String()
				pushData(ip, mac, "", m)
				if strings.Contains(m, "Apple") {
					go sendMDNS(ParseIP(arp.SourceProtAddress), iface.ipNet, mac, iface.localHaddr, iface.name)
				} else {
					go sendNBNS(ParseIP(arp.SourceProtAddress), iface.ipNet, mac, iface.localHaddr, iface.name)
				}
			}
		}
	}
}

//sendArpPackage  发送arp包 ip 目标IP地址
func sendArpPackage(ip IP, ipNet *net.IPNet, haddr net.HardwareAddr, name string) {
	srcIP := net.ParseIP(ipNet.IP.String()).To4()
	dstIP := net.ParseIP(ip.String()).To4()
	if srcIP == nil || dstIP == nil {
		log.Error("ip 解析出问题")
		return
	}
	// 以太网首部
	// EthernetType 0x0806  ARP
	ether := &layers.Ethernet{
		SrcMAC:       haddr,
		DstMAC:       net.HardwareAddr{0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
		EthernetType: layers.EthernetTypeARP,
	}

	a := &layers.ARP{
		AddrType:          layers.LinkTypeEthernet,
		Protocol:          layers.EthernetTypeIPv4,
		HwAddressSize:     uint8(6),
		ProtAddressSize:   uint8(4),
		Operation:         uint16(1), // 0x0001 arp request 0x0002 arp response
		SourceHwAddress:   haddr,
		SourceProtAddress: srcIP,
		DstHwAddress:      net.HardwareAddr{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
		DstProtAddress:    dstIP,
	}

	buffer := gopacket.NewSerializeBuffer()
	var opt gopacket.SerializeOptions
	gopacket.SerializeLayers(buffer, opt, ether, a)
	outgoingPacket := buffer.Bytes()

	handle, err := pcap.OpenLive(name, 2048, false, 30*time.Second)
	if err != nil {
		// log.Errorf("pcap打开失败: %+v", err)
		return
	}
	defer handle.Close()

	err = handle.WritePacketData(outgoingPacket)
	if err != nil {
		log.Errorf("发送arp数据包失败.. %+v", err)
		return
	}
}
