@tool
extends Node

const TEXTURE_SIZE := 2048

@export var ease_value := 1.

@export var generate_texture := false:
    set(v):
        print("generate_texture")
        _generate_texture()

var parent: PointLight2D
var camera: Camera

func work(image: Image, angle: float, x: int): # how can i get the gpu to do this?
    for y in range(TEXTURE_SIZE):
        var v := Vector2(x - TEXTURE_SIZE / 2, y - TEXTURE_SIZE / 2)
        if abs(v.angle()) > deg_to_rad(angle / 2):
            continue
        var value: float = max(0.0, lerp(1.0, 0.0, ease(inverse_lerp(
                0, TEXTURE_SIZE / 2, v.length()), ease_value)
        ))
        var color := Color(value, value, value)
        
        #print("{0}, {1}: {2}".format([x, y, color]))
        
        image.set_pixel(x, y, color)

func _generate_texture():
    var angle := camera.angle
    var filename := "res://CameraTextures/{0}-{1}-{2}.png" \
        .format([angle, ease_value, TEXTURE_SIZE])
        
    # first, lets check that the texture doesn't already exist
    if FileAccess.file_exists(filename):
        # easy
        print("Reusing existing image file.")
        parent.texture = load(filename)
    else:
        # not so easy
        print("Generating image file.")
        var image := Image.new()
        image.crop(TEXTURE_SIZE, TEXTURE_SIZE)
        
        var threads: Array[Thread]
        for x in range(TEXTURE_SIZE):
            work(image, angle, x)
        
        print("done!")
        
        image.save_png(filename)
        parent.texture = ImageTexture.create_from_image(Image.load_from_file(filename))
        print("set texture")

func _ready():
    assert(get_parent() is PointLight2D)
    parent = get_parent()
    camera = Get.ancestor_of_type(get_parent(), Camera)
