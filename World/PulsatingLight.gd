extends PointLight2D

@export var frequency := 1
@export var amplitude := 1
var t := 0.0
func _process(delta):
    t = fmod(t + delta * frequency, PI)
    
    energy = 1 + sin(t) * amplitude
