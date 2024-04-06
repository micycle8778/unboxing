class_name Get
extends Object

static func component_or_null(parent: Node, type: Object) -> Node:
    if type is Script: # if it's a GDScript type
        for child in parent.get_children():
            if child.get_script() == type:
                return child
        return null
    else: # if it's a built-in type
        for child in parent.get_children():
            if child.is_class(type.new().get_class()):
                return child
        return null

static func component(parent: Node, type: Object) -> Node:
    var result := component_or_null(parent, type)
    assert(result != null)
    return result

static func all_components(parent: Node, type: Object) -> Array[Node]:
    var result: Array[Node]
    if type is Script: # if it's a GDScript type
        for child in parent.get_children():
            if child.get_script() == type:
                result.push_back(child)
    else: # if it's a built-in type
        for child in parent.get_children():
            if child.is_class(type.new().get_class()):
                result.push_back(child)
    return result
