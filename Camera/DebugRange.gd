@tool
extends Node2D

@export var color: Color

var parent: Camera

func _draw():
    var points := PackedVector2Array()
    
    points.push_back(Vector2())
    var d_theta = deg_to_rad(parent.angle / 32)
    for i in range(-15,16):
        points.push_back(Vector2.RIGHT.rotated(d_theta * i) * parent.range)
    points.push_back(Vector2())    
    
    draw_polygon(points, PackedColorArray([color]))

func _process(_delta):
    if visible:
        queue_redraw()

func _ready():
    assert(get_parent() is Camera)
    parent = get_parent()
