extends Resource
class_name FileSystem

# Dette er filen som håndterer spillerens filsystem

# Regler for bruken av filsystemet:
# 	- Alle "current_path"-felt skal være absolutt til der spilleren står.
#	  De skal også alltid slutte med "/". Eksempel: "/A/B/C/", "/etc/", "/lol/lil/lel/"

# Rotkatalogen på topp av strukturen
var root_directory: Directory 

# Filsystemets Errno: Holder på, og klassifiserer feilmeldinger
enum FileError {OK, ENOENT, ENOTDIR, EACCES, EEXIST, EINPTH}
var errno: FileError = FileError.OK


func _init() -> void:
	root_directory = Directory.new("/", null, self)


# Get_file_entity():	Henter en file-entity hvor som helst i filsystemet
func get_file_entity(path: String) -> FileEntity:
	if _path_is_valid(path):
		errno = FileError.EINPTH
		return null

	var path_depth: int = path.get_slice_count("/")
	var file_entity: FileEntity = root_directory.get_entity(path, 1, path_depth)
	if not file_entity.read:
		errno = FileError.EACCES
		return null
	
	return file_entity


# Mkdir():	Lager en katalog på en gitt filsti
func mkdir(path: String) -> bool:
	if not _path_is_valid(path):
		set_error(FileError.EINPTH)
		return false
	
	var dir_name: String = path.get_file()	# get_file() fordi navnet kan ha en extention
	var parent_dir_path: String = path.get_base_dir()
	
	var parent_dir: FileEntity = root_directory.get_entity(parent_dir_path, 1, parent_dir_path.get_slice_count("/"))
	if not is_instance_of(parent_dir, Directory):
		set_error(FileError.ENOTDIR)
		return false
	
	return (parent_dir as Directory).insert_into(Directory.new(dir_name, parent_dir, self))


# Exists():	Returnerer en bool basert på om et element eksisterer eller ikke
func exists(path: String) -> bool:
	return root_directory.get_entity(path, 1, path.get_slice_count("/")) != null


# Check_error():	Returnerer innholdet i errno og resetter det
func check_error() -> FileError:
	var err_code: FileError = errno
	errno = FileError.OK
	return err_code


# Set_error():		Setter innholdet i errno
func set_error(err_code: FileError) -> void:
	errno = err_code
	print("Error: ", errno)
	

# Skal gjøre en filsti absolutt
func _make_path_absoulute(path: String, current_path: String) -> String:
	if path.is_absolute_path() && not path.contains(" "):
		return path
	elif path.is_relative_path():
		return current_path + path
	else:
		return "INVALID"


# Sjekker om en gitt filsti er gyldig
func _path_is_valid(path: String) -> bool:
	if not path.is_absolute_path():
		return false

	# Håndter edgecaser
	if path.begins_with("res://") || path.begins_with("user://") || path.begins_with("C:\\"):
		return false
	
	return true
	
	
	
	
	
	
	
	
	
	
	
	
