class_name Camera
extends StaticBody2D

@export var range := 1300.0
@export var angle := 45.0

func print_class(obj: Node):
    print(obj.get_class())

@onready var ray_cast_2d: RayCast2D = %RayCast2D
func _ready():
    ray_cast_2d.add_exception(self)
    
func _process(_delta):
    ray_cast_2d.target_position = ray_cast_2d.to_local(Player.instance.global_position).normalized() * range
    ray_cast_2d.force_raycast_update()
    if \
        ray_cast_2d.is_colliding() \
        and ray_cast_2d.get_collider() == Player.instance \
        and abs(ray_cast_2d.to_local(ray_cast_2d.get_collision_point()).angle()) < deg_to_rad(angle / 2):
            Player.instance.watchers[self] = true
    else:
        Player.instance.watchers.erase(self)
