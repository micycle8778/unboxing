extends Node

class SaveData:
    var seen_tutorials := {}

const filename := "user://save.dat"
var data := SaveData.new()

func have_seen_tutorial(id: int) -> bool:
    return id in data.seen_tutorials

func register_seen_tutorial(id: int):
    data.seen_tutorials[id] = true

func save_data():
    var f := FileAccess.open(filename, FileAccess.WRITE)
    f.store_var(data, true) # Scary!
    f.flush()
    f.close()

func load_data() -> bool:
    if FileAccess.file_exists(filename):
        var f := FileAccess.open(filename, FileAccess.READ)
        data = f.get_var(true) # Scary!
        f.close()
        
        print("data = ", data)
        
        if data is SaveData:
            return true
    data = SaveData.new()
    return false

func _ready():
    load_data()

func _exit_tree():
    save_data()
