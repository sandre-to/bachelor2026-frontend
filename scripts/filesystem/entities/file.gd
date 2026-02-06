extends FileEntity
class_name File

# Rettighet: Kjørbar
var exec: bool = false

# Midlertidig en tekstfil :)
var text_content: String

func _init(_name: String, _parent_system: FileSystem) -> void:
	super(_name, _parent_system)


func get_entity(path: String, current_depth: int, path_depth: int) -> FileEntity:
	return self


func _to_string() -> String:
	return name
