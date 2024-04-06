extends Node2D

func _process(delta):
    if Input.is_action_just_pressed("jump"):
        get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(Vector2(2,2))
