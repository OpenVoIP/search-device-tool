package scan

import (
	"fmt"
	"scan/internal"
	"scan/utils"
	"sort"
	"strings"

	log "github.com/sirupsen/logrus"

	"github.com/360EntSecGroup-Skylar/excelize"
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
	channel.HandleFunc("download", p.download)

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
		value := fmt.Sprintf("%s###%s###%s###%s", k.String(), mac, d.Hostname, d.Manuf)
		Results[k.String()] = value
	}
}

// handle 处理
func (p *PluginInfo) handle(arguments interface{}) (reply interface{}, err error) {
	internal.Scan("", PrintData)
	return Results, nil
}

func (p *PluginInfo) download(arguments interface{}) (replay interface{}, err error) {
	log.Info("创建下载文件")
	file := excelize.NewFile()
	file.DeleteSheet("Sheet1")

	// Create a new sheet.
	index := file.NewSheet("设备信息")

	// Set value of a cell.
	log.Info("设置文件 title")
	file.SetCellValue("设备信息", "A1", "IP")
	file.SetCellValue("设备信息", "B1", "MAC")
	file.SetCellValue("设备信息", "C1", "Hostname")
	file.SetCellValue("设备信息", "D1", "Manuf")

	log.Info("设置文件值")
	count := 1
	for _, value := range Results {
		count++
		info := value.(string)
		data := strings.Split(info, "###")
		log.Info(info, data[0], data[1], data[2], data[3])
		file.SetCellValue("设备信息", fmt.Sprintf("A%d", count), data[0])
		file.SetCellValue("设备信息", fmt.Sprintf("B%d", count), data[1])
		file.SetCellValue("设备信息", fmt.Sprintf("C%d", count), data[2])
		file.SetCellValue("设备信息", fmt.Sprintf("D%d", count), data[3])
	}

	// Set active sheet of the workbook.
	log.Info("保存 sheet")
	file.SetActiveSheet(index)

	// Save xlsx file by the given path.
	home, err := utils.Home()
	if err != nil {
		log.Error(err)
		return "获取用户目录失败", nil
	}
	log.Infof("保存到目录 %s", home)
	if err := file.SaveAs(fmt.Sprintf("%s/设备信息.xlsx", home)); err != nil {
		log.Error("下载失败 %+v", err)
		return "保存文件失败", nil
	}
	log.Info("下载成功")
	return home, nil
}
