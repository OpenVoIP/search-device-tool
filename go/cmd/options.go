package main

import (
	"scan"

	"github.com/go-flutter-desktop/go-flutter"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(960, 800),
	flutter.WindowDimensionLimits(800, 600, 1400, 1200),
	flutter.AddPlugin(&scan.PluginInfo{}),
}
