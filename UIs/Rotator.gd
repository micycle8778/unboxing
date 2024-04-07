extends Node

@export var min_rotation_speed := 25.0
@export var max_rotation_speed := 45.0
@export var start_after := 0.0


@onready var rotation_speed := randf_range(min_rotation_speed, max_rotation_speed)

func _process(delta):
    if start_after <= 0:
        get_parent().rotation_degrees += delta * rotation_speed
    else:
        start_after -= delta
