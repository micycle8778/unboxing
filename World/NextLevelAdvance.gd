extends Area2D

const worlds_path := "res://World/Worlds/"
@export var win_screen: PackedScene

@onready var world_id := int(Get.ancestor_of_type(get_parent(), World).scene_file_path.split("/")[-1].split(".")[0])

func _on_body_entered(body):
    if body is Player:
        var filename = worlds_path + str(world_id + 1) + ".tscn"
        if FileAccess.file_exists(filename):
            get_tree().change_scene_to_file.call_deferred(filename)
        else:
            get_tree().change_scene_to_packed.call_deferred(win_screen)

func _ready():
    print(
        
    )
