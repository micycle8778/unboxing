extends RigidBody2D

@onready var timer = %Timer
func _ready():
    # set kill time
    timer.start(randf_range(3, 5))
    
    # fling the particles up
    apply_central_impulse(
        randf_range(50, 500) * \
        Vector2.UP.rotated(deg_to_rad(randf_range(-45, 45)))
    )
    
    apply_torque_impulse(randf_range(100, 1000))
