@abstract
extends Resource
class_name FileEntity

# Identitet
var name: String

# Rettigheter
var read: bool	= true
var write: bool	= true

# Filsystemet enheten tilhører
var parent_fs

func _init(_name: String, _parent_fs: FileSystem) -> void:
	self.name = _name
	self.parent_fs = _parent_fs

@abstract
func get_entity(path: String, current_depth: int, path_depth: int) -> FileEntity
