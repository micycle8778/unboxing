class_name DebugRayCast
extends Node2D

@export var player_only := true
var parent: RayCast2D
func _ready():
    assert(get_parent() is RayCast2D)
    parent = get_parent()

func _draw():
    draw_line(
        Vector2(), 
        
        to_local(parent.get_collision_point()) if parent.is_colliding() 
        else parent.target_position,
            
        Color.FUCHSIA if 
            (parent.is_colliding() and not player_only) 
            or (parent.is_colliding() and Player.instance == parent.get_collider())
        else Color.BLACK,
        5 
    )
    
func _process(_delta):
    queue_redraw()
