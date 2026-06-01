hl.device({
    name = "apple-spi-trackpad",
    sensitivity = 0.,
    natural_scroll = true
})


hl.config({
    input = {
        touchpad = {
            tap_to_click = false,
            clickfinger_behavior = true
        }
    }
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace"})
hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER", action = "move"})
hl.gesture({ fingers = 2, direction = "pinch", mods = "SUPER", action = "float"})
hl.gesture({ fingers = 2, direction = "pinch", mods = "alt", action = "resize"})


