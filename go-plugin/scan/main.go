package scan

import (
	"errors"
	"fmt"
	"os/exec"
	"runtime"
	"scan/internal"
	"scan/utils"
	"sort"
	"strings"
	"sync"

	"github.com/dgrijalva/jwt-go"
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
	channel.HandleFunc("startScan", p.scan)
	channel.HandleFunc("download", p.download)
	channel.HandleFunc("open_url", p.openURL)
	channel.HandleFunc("create_token", p.createToken)

	//init
	p.stop = make(chan bool, 1)

	return nil // no error
}

//HandleScanData 打印数据
func HandleScanData(deviceInfos *sync.Map) {

	Results = make(map[interface{}]interface{})
	var keys internal.IPSlice
	deviceInfos.Range(func(k, v interface{}) bool {
		keys = append(keys, internal.ParseIPString(k.(string)))
		sort.Sort(keys)
		return true
	})
	sort.Sort(keys)

	for _, key := range keys {
		d, _ := deviceInfos.Load(key.String())
		mac := ""
		if d.(internal.Info).Mac != nil {
			mac = d.(internal.Info).Mac.String()
		}
		value := fmt.Sprintf("%s###%s###%s###%s###%s", key.String(), mac, d.(internal.Info).Hostname, d.(internal.Info).Manuf, d.(internal.Info).Model)
		// log.Infof("scan value %s", value)
		Results[key.String()] = value
	}
}

// scan 处理
func (p *PluginInfo) scan(arguments interface{}) (reply interface{}, err error) {
	internal.Scan("", HandleScanData)
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

func (p *PluginInfo) openURL(arguments interface{}) (replay interface{}, err error) {
	switch runtime.GOOS {
	case "windows":
		exec.Command(`cmd`, `/c`, `start`, arguments.(string)).Start()
	case "darwin":
		exec.Command(`open`, arguments.(string)).Start()
	case "linux":
		exec.Command(`xdg-open`, arguments.(string)).Start()
	default:
		return nil, errors.New("not support platform")
	}

	return nil, nil
}

func (p *PluginInfo) createToken(arguments interface{}) (replay interface{}, err error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		// "nbf": time.Date(2015, 10, 10, 12, 0, 0, 0, time.UTC).Unix(),
	})

	tokenString, err := token.SignedString([]byte(arguments.(string)))
	if err != nil {
		log.Fatal("createToken", err)
		return nil, err
	}

	return tokenString, nil
}
