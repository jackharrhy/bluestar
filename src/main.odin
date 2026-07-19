package main

import sdl "vendor:sdl3"

main :: proc() {
	ok := sdl.Init({.VIDEO})
	assert(ok)
	defer sdl.Quit()

	window := sdl.CreateWindow("Bluestar", 1280, 720, {.RESIZABLE})
	assert(window != nil)
	defer sdl.DestroyWindow(window)

	shader_formats := sdl.GPUShaderFormat{.SPIRV, .DXIL, .MSL}
	device := sdl.CreateGPUDevice(shader_formats, ODIN_DEBUG, nil)
	assert(device != nil)
	defer sdl.DestroyGPUDevice(device)

	ok = sdl.ClaimWindowForGPUDevice(device, window)
	assert(ok)
	defer sdl.ReleaseWindowFromGPUDevice(device, window)

	running := true
	for running {
		event: sdl.Event
		for sdl.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				running = false
			}
		}
	}
}
