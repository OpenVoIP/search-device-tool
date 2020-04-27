package utils

import "runtime"

//IsWindows is windows system
func IsWindows() bool {
	return runtime.GOOS == "windows"
}
