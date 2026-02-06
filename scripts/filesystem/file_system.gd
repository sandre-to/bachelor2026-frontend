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


# Mkdir():	Lager en katalog på en gitt sti
func mkdir(path: String, current_path: String) -> bool:
	
	var abs_path: String = _make_path_absoulute(path, current_path)
	if abs_path == "INVALID":
		errno = FileError.ENOTDIR
		return false
	
	var dir_name: String = abs_path.get_file().get_slice(".", 0)
	var parent_path: String = abs_path.get_base_dir()

	var path_depth: int = parent_path.get_slice_count("/")
	var parent_dir: Directory = root_directory.get_entity(parent_path, 1, path_depth)
	if parent_dir == null:
		return false
	return parent_dir.insert_into(Directory.new(dir_name, parent_dir, self))


# Touch():	Lager en tom fil på en gitt sti
func touch(path: String, current_path: String) -> bool:
	
	var abs_path: String = _make_path_absoulute(path, current_path)
	if abs_path == "INVALID":
		errno = FileError.ENOTDIR
		return false
		
	var base_path: String = abs_path.get_base_dir()
	var base_depth: int = base_path.get_slice_count("/")
	var base_dir: Directory = root_directory.get_entity(base_path, 1, base_depth)
	if base_dir == null:
		return false

	return base_dir.insert_into(File.new(abs_path.get_file(), self))


# Ls():		Returnerer en string med innholdet til en gitt string
func ls(path: String, current_path: String) -> String:
	var abs_path: String = _make_path_absoulute(path, current_path)
	var path_depth: int = abs_path.get_slice_count("/")
	# bla bla

	return root_directory.get_entity(abs_path, 1, path_depth).to_string()


# Cp():		Kopierer en fil fra en sti til en annen
func cp(from_path: String, to_path: String, current_path: String) -> bool:
	var abs_from_path: String = _make_path_absoulute(from_path, current_path)
	if abs_from_path == "INVALID":
		return false

	var abs_to_path: String = _make_path_absoulute(to_path, current_path)
	if abs_to_path == "INVALID":
		return false
		
	var file_to_copy: FileEntity = root_directory.get_entity(abs_from_path, 1, abs_from_path.get_slice_count("/"))
	if file_to_copy == null:
		return false
	elif not is_instance_of(file_to_copy, File):
		print("LOLLLLl")
		set_error(FileError.ENOENT)
		return false
	
	var base_to_path: String = abs_to_path.get_base_dir()
	var base_to_dir: FileEntity = root_directory.get_entity(base_to_path, 1, base_to_path.get_slice_count("/"))
	if base_to_dir == null:
		return false
	elif not is_instance_of(base_to_dir, Directory):
		set_error(FileError.ENOTDIR)
		return false
		
	return (base_to_dir as Directory).insert_into(file_to_copy)


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

	
	
	
	
	
	
	
	
	
	
	
	
	
