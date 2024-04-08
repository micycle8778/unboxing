extends Area2D

const worlds_path := "res://World/Worlds/"
@export var next_scene: PackedScene

@onready var world_id := int(Get.ancestor_of_type(get_parent(), World).scene_file_path.split("/")[-1].split(".")[0])

func _on_body_entered(body):
    if body is Player:
        var filename = worlds_path + str(world_id + 1) + ".tscn"
        get_tree().change_scene_to_packed.call_deferred(next_scene)

func _ready():
    print(
        
    )
