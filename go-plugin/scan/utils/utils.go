package utils

import (
	"runtime"
	"strings"
)

//Buffer data
type Buffer struct {
	data  []byte
	start int
}

//GetData buffer data
func (b *Buffer) GetData() []byte {
	return b.data
}

//PrependBytes
func (b *Buffer) PrependBytes(n int) []byte {
	length := cap(b.data) + n
	newData := make([]byte, length)
	copy(newData, b.data)
	b.start = cap(b.data)
	b.data = newData
	return b.data[b.start:]
}

//NewBuffer init buffer
func NewBuffer() *Buffer {
	return &Buffer{}
}

//Reverse 反转字符串
func Reverse(s string) (result string) {
	for _, v := range s {
		result = string(v) + result
	}
	return
}

//IsWindows is windows system
func IsWindows() bool {
	return runtime.GOOS == "windows"
}

//GetModel 根据 mac 获取型号
func GetModel(mac string) string {
	if !strings.HasPrefix(mac, "68:69:2e") {
		return ""
	}
	var info = strings.Split(mac, ":")[3]
	return MACModelMap[info]
}
