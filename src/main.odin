package main

import sdl "vendor:sdl3"

main :: proc() {
	ok := sdl.Init({.VIDEO})
	assert(ok)
	defer sdl.Quit()

	window := sdl.CreateWindow("Bluestar", 1280, 720, {.RESIZABLE})
	assert(window != nil)
	defer sdl.DestroyWindow(window)

	renderer := sdl.CreateRenderer(window, nil)
	assert(renderer != nil)
	defer sdl.DestroyRenderer(renderer)

	running := true
	for running {
		event: sdl.Event
		for sdl.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				running = false
			}
		}

		draw_checkerboard(renderer)
	}
}

draw_checkerboard :: proc(renderer: ^sdl.Renderer) {
	cell_size_i: i32 = 64
	cell_size := f32(cell_size_i)
	width, height: i32
	ok := sdl.GetCurrentRenderOutputSize(
		renderer,
		&width,
		&height,
	)
	assert(ok)
	columns := (width + cell_size_i - 1) / cell_size_i
	rows := (height + cell_size_i - 1) / cell_size_i

	ok = sdl.SetRenderDrawColor(
		renderer,
		9,
		9,
		11,
		255,
	)
	assert(ok)
	ok = sdl.RenderClear(renderer)
	assert(ok)

	for y in 0 ..< rows {
		for x in 0 ..< columns {
			if (x + y) % 2 == 0 {
				ok = sdl.SetRenderDrawColor(
					renderer,
					32,
					94,
					166,
					255,
				)
			} else {
				ok = sdl.SetRenderDrawColor(
					renderer,
					225,
					236,
					235,
					255,
				)
			}
			assert(ok)

			rect := sdl.FRect{
				x = f32(x) * cell_size,
				y = f32(y) * cell_size,
				w = cell_size,
				h = cell_size,
			}
			ok = sdl.RenderFillRect(
				renderer,
				&rect,
			)
			assert(ok)
		}
	}

	ok = sdl.RenderPresent(renderer)
	assert(ok)
}
