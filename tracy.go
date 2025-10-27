package tracy

import "github.com/0xsoniclabs/tracy/internal"

func StartupProfiler() {
	internal.StartupProfiler()
}

func ShutdownProfiler() {
	internal.ShutdownProfiler()
}

func FrameMark() {
	internal.FrameMark()
}

type Zone = internal.Zone

func ZoneBegin(name string) Zone {
	return internal.ZoneBegin(name)
}
