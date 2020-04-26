package scan

import (
	"fmt"
	"scan/internal"
	"sort"

	flutter "github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
)

const channelName = "tqcenglish.flutter.dev/scan"

// PluginInfo 插件信息
type PluginInfo struct {
	stop chan bool
}

var _ flutter.Plugin = &PluginInfo{} // compile-time type check

//Results 扫描结果
var Results map[interface{}]interface{}

//InitPlugin inits
func (p *PluginInfo) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewMethodChannel(messenger, channelName, plugin.StandardMethodCodec{})
	channel.HandleFunc("startScan", p.handle)

	//init
	p.stop = make(chan bool, 1)

	return nil // no error
}

//PrintData 打印数据
func PrintData(deviceInfos map[string]internal.Info) {
	Results = make(map[interface{}]interface{})
	var keys internal.IPSlice
	for k := range deviceInfos {
		keys = append(keys, internal.ParseIPString(k))
	}
	sort.Sort(keys)
	for _, k := range keys {
		d := deviceInfos[k.String()]
		mac := ""
		if d.Mac != nil {
			mac = d.Mac.String()
		}
		value := fmt.Sprintf("%-15s###%-17s###%-30s###%-10s", k.String(), mac, d.Hostname, d.Manuf)
		Results[k.String()] = value
	}
}

// handle 处理
func (p *PluginInfo) handle(arguments interface{}) (reply interface{}, err error) {
	internal.Scan("", PrintData)
	return Results, nil
}
