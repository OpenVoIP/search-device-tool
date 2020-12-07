package main

import (
	"scan"

	"github.com/go-flutter-desktop/go-flutter"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1000, 600),
	flutter.WindowDimensionLimits(1000, 600, 1900, 1200),
	flutter.AddPlugin(&scan.PluginInfo{}),
}
