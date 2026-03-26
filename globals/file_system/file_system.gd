extends Node

# Dette er filen som håndterer spillerens filsystem

# Regler for bruken av filsystemet:
#	- Alle metoder i FileSystem-objekter krever absolutte filstier
#	- På directory-objekt kan man bruke relative filstier (Fra den katalogen)

# Rotkatalogen på topp av strukturen
var root_directory: Directory 

# Filsystemets Errno: Holder på, og klassifiserer feilmeldinger
enum FileError {OK, ENOENT, ENODIR, EACCES, EEXIST, EINPTH}
var errno: FileError = FileError.OK

func _ready() -> void:
	root_directory = Directory.new("/", null)
	mkdir("/home")
	mkdir("/home/pictures")
	mkdir("/home/documents")
	mkdir("/home/secrets")
	touch("/home/pictures/cat.png")
	touch("/home/documents/tutorial.txt").text_content = "lær det idgaf"

	
	
	


# Get_file_entity():	Henter en file-entity hvor som helst i filsystemet.
#						Kan feile dersom:
#						- Filstien ikke er gyldig formatert (EINPTH).
#						- get_entity() feiler (ENOENT)
func get_file_entity(path: String) -> FileEntity:
	if not _path_is_valid(path):
		set_error(FileError.EINPTH)
		return null

	return root_directory.get_entity(path)


# Mkdir():	Lager en katalog på en gitt filsti
#			Kan feile dersom:
#			- Filstien ikke er gyldig formatert (EINPTH).
#			- Entiteten get_entity() returnerte var en fil (ENOTDIR).
#			- get_entity() feiler (ENOENT, EACCES)
func mkdir(path: String) -> Directory:
	if not _path_is_valid(path):
		set_error(FileError.EINPTH)
		return null
	
	var dir_name: String = path.get_file()	# get_file() fordi navnet kan ha en extention
	
	var parent_dir: FileEntity = root_directory.get_entity(path.get_base_dir())
	
	if parent_dir == null:
		return null
	if not is_instance_of(parent_dir, Directory):
		set_error(FileError.ENODIR)
		return null
	
	return (parent_dir as Directory).insert_into(Directory.new(dir_name, parent_dir)) as Directory


# Touch():	Lager en tom fil på en gitt filsti. Kan feile dersom:
#			- Filstien ikke er gyldig formatert (EINPTH).
#			- Entiteten get_entity() returnerte var en katalog (ENOTDIR).
#			- get_entity() feiler (ENOENT, EACCES)
func touch(path: String) -> File:
	if not _path_is_valid(path):
		set_error(FileError.EINPTH)
		return null
	
	var file_name: String = path.get_file()
	var parent_dir: FileEntity = root_directory.get_entity(path.get_base_dir())
	if parent_dir == null:
		return null
	elif not is_instance_of(parent_dir, Directory):
		set_error(FileError.ENOENT)
		return null
	
	return (parent_dir as Directory).insert_into(File.new(file_name)) as File


# Exists():	Returnerer en bool basert på om et element eksisterer eller ikke
func exists(path: String) -> bool:
	return root_directory.get_entity(path) != null


# Check_error():	Returnerer innholdet i errno og resetter det
func check_error() -> FileError:
	var err_code: FileError = errno
	errno = FileError.OK
	return err_code


# Set_error():		Setter innholdet i errno
func set_error(err_code: FileError) -> void:
	errno = err_code
	

# _path_is_valid():	Sjekker om en gitt filsti er gyldig formatert.
func _path_is_valid(path: String) -> bool:
	if not path.is_absolute_path():
		return false

	# Håndter edgecaser
	if path.begins_with("res://") || path.begins_with("user://") || path.begins_with("C:\\"):
		return false
	
	return true
