@tool
extends Node2D

@export var color: Color

var parent: Camera

const points_count := 128

@onready var ray_cast_2d = %RayCast2D

func _draw():
    var points := PackedVector2Array()
    
    if Player.instance != null:
        ray_cast_2d.add_exception(Player.instance)
    
    points.push_back(Vector2())
    var d_theta = deg_to_rad(parent.angle / points_count)
    for i in range(-points_count / 2 + 1,points_count / 2):
        var ray_dest := Vector2.RIGHT.rotated(d_theta * i) * parent.range
        ray_cast_2d.target_position = ray_cast_2d.to_local(to_global(ray_dest))
        ray_cast_2d.force_raycast_update()
        if ray_cast_2d.is_colliding():
            points.push_back(to_local(ray_cast_2d.get_collision_point()))
        else:
            points.push_back(ray_dest)
        
        if parent.debug:
            print(ray_dest, " ",to_local(ray_cast_2d.get_collision_point()))
    points.push_back(Vector2())  
    
    if parent.debug:
        print()
    
    if Player.instance != null:
        ray_cast_2d.remove_exception(Player.instance)  
    
    draw_polygon(points, PackedColorArray([color]))

func _process(_delta):
    if visible:
        queue_redraw.call_deferred()

func _ready():
    assert(get_parent() is Camera)
    parent = get_parent()
