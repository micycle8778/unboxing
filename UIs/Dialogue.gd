class_name Dialogue
extends Control

@onready var animation_player = %AnimationPlayer
@onready var label = %Label
@onready var advance_hint = %AdvanceHint

@export var texts: Array[DialogueText]
@export var freeze_character := true

signal frame(skip_pressed)

func _process(_delta):
    frame.emit(Input.is_action_just_pressed("jump") and freeze_character)

func _ready():
    advance_hint.visible = freeze_character
    if Player.instance != null:
        Player.instance.can_move = not freeze_character
    
    await animation_player.animation_finished
    
    for t in texts:
        label.text = ""
        for c in t.text:
            label.text += c
            if await frame:
                label.text = t.text
                break
        
        if freeze_character:
            while not await frame: pass
        else:
            await get_tree().create_timer(.5).timeout
    
    animation_player.play_backwards("dropin")
    
    if Player.instance != null:
        Player.instance.can_move = true
    
    await animation_player.animation_finished
    queue_free()
