extends Resource
class_name FileSystem

# Dette er filen som håndterer spillerens filsystem

# Regler for bruken av filsystemet:
# 	- Alle "current_path"-felt skal være absolutt til der spilleren står.
#	  De skal også alltid slutte med "/". Eksempel: "/A/B/C/", "/etc/", "/lol/lil/lel/"

# Rotkatalogen på topp av strukturen
var root_directory: Directory 

# Filsystemets Errno: Holder på, og klassifiserer feilmeldinger
enum FileError {OK, ENOENT, ENOTDIR, EACCES, EEXIST}
var errno: FileError = FileError.OK


func _init() -> void:
	root_directory = Directory.new("/", null, self)


func get_file_entity(path: String, current_path: String) -> FileEntity:	
	var abs_path: String = _make_path_absoulute(path, current_path)
	if abs_path == "INVALID":
		errno = FileError.ENOENT
		return null

	var path_depth: int = abs_path.get_slice_count("/")
	var file_entity: FileEntity = root_directory.get_entity(abs_path, 1, path_depth)
	if not file_entity.read:
		errno = FileError.EACCES
		return null
	
	return file_entity


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
	
	
	return false
	
	
	
	
	
	
	
	
	
	
	
	
