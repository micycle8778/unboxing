@tool
class_name Square
extends Node2D

@export var width := 32.0:
    set(v):
        width = v
        queue_redraw()
@export var height := 32.0:
    set(v):
        height = v
        queue_redraw()
@export var centered := true:
    set(v):
        centered = v
        queue_redraw()
@export var color := Color.WHITE:
    set(v):
        color = v
        queue_redraw()

func _draw():
    var pos := Vector2(-width / 2, -height / 2) if centered else Vector2.ZERO
    draw_rect(Rect2(pos, Vector2(width, height)), color)
