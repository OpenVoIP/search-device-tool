package main

import (
	"fmt"

	"github.com/google/gopacket/pcap"
)

func main() {
	devices, err := pcap.FindAllDevs()
	if err != nil {
		fmt.Print(err)
	}
	fmt.Print("devices")
	fmt.Print(devices)
}
