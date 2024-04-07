class_name Player
extends CharacterBody2D

static var instance: Player

@export var cute_particles: Array[PackedScene]
@export var jump_particles: PackedScene

@export_group("Movement")
@export var gravity := 2000
@export var jump_power := 1000
@export var move_accel := 2500
@export var friction := 10
@export var air_friction := 0.1
@export var max_speed := 1000.0
@export var air_control := .4

var watchers: Dictionary
var watched: bool:
    get: 
        return len(watchers) != 0

@onready var standing = %Standing
@onready var cute = %Cute
@onready var standing_flipped = %StandingFlipped

var flipped := false

func spawn_particles():
    for i in range(randi_range(3, 5)):
        var particle := cute_particles[randi() % len(cute_particles)].instantiate()
        get_parent().add_child(particle)
        particle.global_position = global_position

func _ready():
    instance = self

var last_jump_pressed := -INF
func jump_pressed():
    var result := Time.get_ticks_msec() - last_jump_pressed <= 16 * 4
    if result:
        last_jump_pressed = -INF
    return result

var watched_last_frame := false
func _process(_delta):
    if Input.is_action_just_pressed("jump"):
        last_jump_pressed = Time.get_ticks_msec()
    
    if watched:
        if not watched_last_frame:
            spawn_particles()
        
        cute.visible = true
        cute.flip_h = flipped
        
        standing.visible = false
        standing_flipped.visible = false
    else:
        cute.visible = false
        standing.visible = not flipped
        standing_flipped.visible = flipped
    
    watched_last_frame = watched
    
@onready var left = %Left
@onready var right = %Right
func is_on_side_area() -> bool:
    return left.has_overlapping_bodies() or right.has_overlapping_bodies()

func side_area_normal() -> Vector2:
    assert(is_on_side_area())
    
    if left.has_overlapping_bodies():
        return Vector2.RIGHT
    return Vector2.LEFT

func get_side_area() -> Area2D:
    assert(is_on_side_area())
    
    if left.has_overlapping_bodies():
        return left
    return right

var stored_velocity := 0.0
func _physics_process(delta):
    var horz = Input.get_axis("left", "right")
    
    var overspeed: bool = abs(velocity.x) > max_speed
    var input_disagreement: bool = horz != sign(velocity.x)
    
    if watched:
        horz = 0
    
    if horz < 0:
        flipped = true
    elif horz > 0:
        flipped = false
    
    if is_on_floor():
        if not overspeed or input_disagreement:
            velocity.x += horz * move_accel * delta
        if input_disagreement:
            velocity.x = lerp(velocity.x, 0.0, delta * friction)
            
        if not watched and jump_pressed():
            velocity.y -= jump_power
        
        if overspeed:
             velocity.x = lerp(abs(velocity.x), max_speed, delta * friction) * sign(velocity.x)
    else:
        if horz == 0:
            velocity.x = lerp(velocity.x, 0.0, delta * air_friction)
        elif input_disagreement:
            velocity.x = lerp(velocity.x, 0.0, delta * friction)
        
        velocity.x += horz * move_accel * delta * air_control
        velocity.y += gravity * delta
    
    if is_on_side_area(): 
        if not watched and jump_pressed():
            var mul = max(lerp(2.0, 1.0, inverse_lerp(0, 2000, stored_velocity)), 1)
            velocity = side_area_normal() * stored_velocity * mul
            velocity.y -= jump_power

            var particles := jump_particles.instantiate() as CPUParticles2D
            particles.global_position = global_position
            particles.emitting = true
            particles.finished.connect(particles.queue_free)
            particles.scale.x = side_area_normal().x
            get_parent().add_child(particles)
            
            flipped = side_area_normal() == Vector2.LEFT
    else:
        stored_velocity = velocity.length()
    
    #velocity.x = abs(min(max_speed, abs(velocity.x))) * sign(velocity.x)
    move_and_slide()
