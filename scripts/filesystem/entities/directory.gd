extends FileEntity
class_name Directory

var parent_dir: Directory
var _content: Array[FileEntity]

func _init(_name: String, _parent: Directory, _parent_fs: FileSystem) -> void:
	super(_name, _parent_fs)
	self.parent_dir = _parent


# Get_entity():	Returnerer en entity i filsystemet, starter fra denne katalogen
# Problem:		Mangler filstivalidering; sirkulær avhengighet dersom man bruker
#				FileSystem.path_is_valid()
# Notat:		Filstier her kan jo egt være relative, kanskje man ikke trenger
#				den samme valideringen?
func get_entity(path: String) -> FileEntity:
	return self._recr_get_entity(path, 1, path.get_slice_count("/"))


# Returnerer en entitet rekrusivt
func _recr_get_entity(path: String, current_depth: int, path_depth: int) -> FileEntity:
	# Er vi i bunnen av stien?
	if current_depth == path_depth:
		return self

	var entity_name = path.get_slice("/", current_depth)
	current_depth += 1
	
	# Hvis vi hopper tilbake
	if entity_name == ".." && parent_dir != null:
		return parent_dir._recr_get_entity(path, current_depth, path_depth)
		
	# Hvis vi er i riktig katalog
	elif entity_name == "." || entity_name == "":
		return self._recr_get_entity(path, current_depth, path_depth)

	# Hvis et annet navn
	for entity in _content:
		if entity.name == entity_name && entity.read:
			return entity._recr_get_entity(path, current_depth, path_depth)
		if entity.name == entity_name && not entity.read:
			parent_fs.set_error(FileSystem.FileError.EACCES)
			return null

	parent_fs.set_error(FileSystem.FileError.ENOENT)
	return null


# Returnerer en bool basert på resultatet av funksjonen
func entity_exists(entity_name: String) -> bool:
	for entity in _content:
		if entity.name == entity_name:
			return true
	return false


# Returnerer en bool basert på resultatet av funksjonen
func insert_into(entity: FileEntity) -> bool:
	if not write:
		parent_fs.errno = FileSystem.FileError.EACCES
		return false
	elif entity_exists(entity.name):
		parent_fs.errno = FileSystem.FileError.EEXIST
		return false
	else:
		_content.append(entity)
		return true


func _to_string() -> String:
	return name
	#var stringified_content: String = ""
	#for entity in _content:
		#stringified_content += entity.name + " "
	#return stringified_content
	
	
	
	
	
	
	
	
