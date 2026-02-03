extends FileEntity
class_name Directory

var _content: Array[FileEntity]

func _init(_name: String, _path: String) -> void:
	self.name = _name
	self.path = _path


#func get_content() -> Array:
#	if read == true:
#		return _content


func insert_into(entity: FileEntity) -> bool:
	return false
