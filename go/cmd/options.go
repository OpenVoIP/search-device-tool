package main

import (
	"scan"

	"github.com/go-flutter-desktop/go-flutter"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 1280),
	flutter.WindowDimensionLimits(800, 600, 1900, 1200),
	flutter.AddPlugin(&scan.PluginInfo{}),
}
