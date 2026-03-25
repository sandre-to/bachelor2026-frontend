extends FileEntity
class_name Directory

var parent_dir: Directory
var _content: Array[FileEntity]

func _init(_name: String, _parent: Directory) -> void:
	super(_name)
	parent_dir = _parent


# Get_entity():	Implementasjon av en abstrakte metode.
func get_entity(path: String) -> FileEntity:
	if path.begins_with("/"):
		return self._recr_get_entity(path, 1, path.get_slice_count("/"))
	return self._recr_get_entity(path, 0, path.get_slice_count("/"))


# _recr_get_entity(): 	Returnerer en entitet rekrusivt. Returnerer null dersom:
#						- Man prøver å hoppe en katalog tilbake fra root-katalogen (ENOENT).
#						- Om entiteten ikke eksisterer (ENOENT).
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
		if entity.name == entity_name:
			if is_instance_of(entity, Directory):									#	Hack
				return entity._recr_get_entity(path, current_depth, path_depth)		#	Hack
			else:																	#	Hack
				return entity														#	Hack :(
		if entity.name == entity_name:
			FileSystem.set_error(FileSystem.FileError.EACCES)
			return null

	FileSystem.set_error(FileSystem.FileError.ENOENT)
	return null


# Entity_exists():	Finner ut om en entitet eksisterer i katalogen
func entity_exists(entity_name: String) -> bool:
	for entity in _content:
		if entity.name == entity_name:
			return true
	return false


# Insert_into():	Legger til en entitet i katalogen. Returenere en bool
#					basert på om det fungerte. Kan feile dersom:
#					- Man har ikke skriverettigheter (EACCES).
#					- En entitet med samme navn eksisterer (EEXIST).
func insert_into(entity: FileEntity) -> bool:
	if not write:
		FileSystem.set_error(FileSystem.FileError.EACCES)
		return false
	elif entity_exists(entity.name):
		FileSystem.set_error(FileSystem.FileError.EEXIST)
		return false
	else:
		_content.append(entity)
		return true


# Ls():	En metode som etterligner ls.
func ls() -> String:
	var content: String = ""
	for entity in _content:
		content += entity.name + " "
	return content


func _to_string() -> String:
	return name + ": Directory, " + "Rights: " + get_user_rights()
