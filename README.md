# Tracy

> ⚠️ This is an early-stage project with unstable interfaces. Usage at own risk.

Tracy is a Go library for instrumenting applications for the 
[Tracy](https://github.com/wolfpld/tracy) Frame Profiler. 

To facilitate the tracing of events in multi-language projects, this library
links dynamically to a (shared) Tracy Client library that needs to be build
independently. This enables the combined tracing of events from Go, Rust, C++, 
or other components linked into a single application.

## Usage
This package can be included in any Go code by importing it using
```Go
import "github.com/0xsoniclabs/tracy"
```
If you are implementing a binary, you must start-up the profiler manually using
```Go
tracy.StartupProfiler()
```
before passing any other instrumentation code. This will establish a connection
to an external Tracy profiler and report events. To shut down the connection at
the end of your application, call
```Go
tracy.ShutdownProfiler()
```

To instrument code zones, use the following code:
```Go
zone := tracy.BeginZone("myZoneLabel")
```
This automatically captures the current function name and code location in the
trace. To end the zone, use
```Go
zone.End()
```
The begin and end of a zone must be processed by the same go-routine. A typical
use case would combine these into
```Go
zone := tracy.BeginZone("myZoneLabel")
defer zone.End()
```
to cover the duration of a function.

## Building

By default, the instrumentation is disabled. To enable it, the `tracy` submodule
must be checked out and the build tag `enable_tracy` must be provided.
```bash
go build --tags=enable_tracy ./...
```
When enabled, the resulting executable requires access to shared library 
offering the Tracy Client functionality. To build the shared Tracy library, run
the following command in the root directory of this project
```bash
make tracy/build/libTracyClient.so
```
You might have to update your LD_LIBRARY_PATH for your executable to find this
shared library.

## Inspection
You can use the command
```bash
make tracy/profiler/build/tracy_profiler
```
to build Tracy's profiler tool and
```bash
./tracy/profiler/build/tracy_profiler
```
to run it to collect and visualize tracing data of instrumented code.
