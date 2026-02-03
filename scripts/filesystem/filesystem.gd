extends Resource
class_name FileSystem

var root_directory: String = "/"

var structure: Array[FileEntity]

func _init() -> void:
	var _root_directory = Directory.new(root_directory, root_directory)
