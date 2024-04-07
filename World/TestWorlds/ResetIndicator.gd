extends Label

func _ready():
    position.x = -size.x

var shown := false

func _process(delta):
    var player = Player.instance
    
    if player != null and not shown: # check player is in scene
        # check if the player is moving or not being watched         
        if player.watched and player.velocity.is_zero_approx():
            # show the label
            var tween = get_tree().create_tween()
            
            tween.tween_property(
                self, 
                "position", 
                Vector2(50, 0), 
                1.5
            ).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
            
            shown = true
    
    if Input.is_action_just_pressed("reset"):
        get_tree().reload_current_scene()
