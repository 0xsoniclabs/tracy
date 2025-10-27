.PHONY: all clean test

# Optional flag to enable X11 support in Tracy profiler application (USE_X11==true).
# The default is wayland only (USE_X11!=false).
USE_X11 ?= false

ifeq ($(USE_X11),true)
	TRACY_CMAKE_FLAGS += -DLEGACY=1
endif

all: tracy/build/libTracyClient.so

# Builds the Tracy client library as a shared object required by the Go bindings.
tracy/build/libTracyClient.so:
	@cd ./tracy ; \
	cmake -B build -DCMAKE_BUILD_TYPE=Release -DTRACY_STATIC=false -DTRACY_MANUAL_LIFETIME=true -DTRACY_DELAYED_INIT=true ; \
	cmake --build build --config Release --parallel

# Builds the Tracy profiler application that can 
tracy/profiler/build/tracy_profiler:
	@cd ./tracy ; \
	cmake -B profiler/build -S profiler -DCMAKE_BUILD_TYPE=Release $(TRACY_CMAKE_FLAGS) ; \
	cmake --build profiler/build --config Release --parallel

tracy_profiler: tracy/profiler/build/tracy_profiler

clean:
	@rm -rf ./tracy/build
	@rm -rf ./tracy/profiler/build
	go clean ./...

test: tracy/build/libTracyClient.so
	go test -race -count 1 ./...
	go test -race -count 1 -tags=enable_tracy ./...