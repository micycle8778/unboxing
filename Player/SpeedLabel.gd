extends Label

func _process(_delta):
    text = "Speed: {0}px/s\nHorizontal Speed: {1}px/s\nVertical Speed: {2}px/s".format([
        snapped(Player.instance.velocity.length(), 0.01),
        snapped(abs(Player.instance.velocity.x), 0.01),
        snapped(abs(Player.instance.velocity.y), 0.01)
    ])
