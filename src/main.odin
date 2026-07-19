package main

import sdl "vendor:sdl3"

main :: proc() {
	ok := sdl.Init({.VIDEO})
	assert(ok)
	defer sdl.Quit()

	window := sdl.CreateWindow("Bluestar", 1280, 720, {.RESIZABLE})
	assert(window != nil)
	defer sdl.DestroyWindow(window)

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
