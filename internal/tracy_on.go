//go:build enable_tracy

package internal

import "github.com/0xsoniclabs/tracy/internal/tracy"

func StartupProfiler() {
	tracy.StartupProfiler()
}

func ShutdownProfiler() {
	tracy.ShutdownProfiler()
}

func FrameMark() {
	tracy.FrameMark()
}

type Zone = tracy.Zone

func ZoneBegin(name string) Zone {
	return tracy.ZoneBegin(name)
}
