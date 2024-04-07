@tool
extends Area2D

@export var dialogue_prefab: PackedScene
@export var texts: Array[DialogueText]
@export var freeze_player := true
@export var tutorial := false

@export var id := 0
@export var generate_id := false:
    set(v):
        id = randi()

func _enter_tree():
    if Engine.is_editor_hint() and id == 0:
        id = randi()

func _ready():
    if tutorial and SaveManager.have_seen_tutorial(id):
        queue_free()

func _on_body_entered(body):
    if body is Player:
        # setup
        var dialogue := dialogue_prefab.instantiate() as Dialogue
        dialogue.texts = texts
        dialogue.freeze_character = freeze_player
        
        # find parent and add child
        var parent: CanvasLayer = Get.ancestor_of_type(get_parent(), World).ui_layer
        parent.add_child(dialogue)
        
        # cleanup
        if tutorial:
            SaveManager.register_seen_tutorial(id)
        queue_free()
