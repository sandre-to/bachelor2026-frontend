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

# Initialiserte katalogstier
const HOME_DIR: String = "/home"
const PICTURE_DIR: String = "/home/pictures"
const DOCUMENT_DIR: String = "/home/documents"
const SECRET_DIR: String = "/home/secrets"


func _ready() -> void:
	root_directory = Directory.new("/", null)
	_init_file_structure()



# Get_file_entity():	Henter en file-entity hvor som helst i filsystemet.
#						Kan feile dersom:
#						- Filstien ikke er gyldig formatert (EINPTH).
#						- get_entity() feiler (ENOENT)
func get_file_entity(path: String) -> FileEntity:
	if not _path_is_valid(path):
		set_error(FileError.EINPTH)
		return null

	return root_directory.get_entity(path)



# Insert_into():	Legger en filentitet til en filsti
func insert_into(path: String, file_entity: FileEntity) -> bool:
	var parent: FileEntity = get_file_entity(path)
	if parent is not Directory:
		set_error(FileError.ENODIR)
		return false
	
	return (parent as Directory).insert_into(file_entity) != null



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


# Touch():	Lager en tom tekstfil på en gitt filsti. Kan feile dersom:
#			- Filstien ikke er gyldig formatert (EINPTH).
#			- Entiteten get_entity() returnerte var en katalog (ENOTDIR).
#			- get_entity() feiler (ENOENT, EACCES)
func touch(path: String) -> TextFile:
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
	
	return (parent_dir as Directory).insert_into(TextFile.new(file_name)) as TextFile


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


# add_image_file():	Legger til en bildefil med bildet fra en reel fil
func add_image_file(_name: String, _real_path: String, _target_dir: String = PICTURE_DIR) -> ImageFile:
	var _image_file: ImageFile = ImageFile.new(_name, _real_path)
	return _image_file if insert_into(_target_dir, _image_file) else null


# add_text_file():	Legger til en tekstfil med innholdet fra en reel fil
func add_text_file(_name: String, _target_dir: String, _real_path: String, _rights: String = "r--") -> TextFile:
	var file: TextFile = touch(_target_dir + "/" + _name)
	var file_access: FileAccess = FileAccess.open(_real_path, FileAccess.READ)
	if file_access == null or file == null:
		return null
		
	file.update_content(file_access.get_as_text())
	file.chmod(_rights)
	return file
	

func _init_file_structure() -> void:
	mkdir(HOME_DIR)
	mkdir(PICTURE_DIR)
	mkdir(DOCUMENT_DIR)
	mkdir(SECRET_DIR)
	
	add_image_file("carrotEater", "res://scenes/file_explorer/pictures/prince.png")
	add_image_file("bunnyEater", "res://scenes/file_explorer/pictures/petter.jpg")
	add_image_file("saintSofelin", "res://scenes/file_explorer/pictures/devSofie.png")
	add_image_file("merlinsBeard", "res://scenes/file_explorer/pictures/devJesus.jpg")
	add_image_file("bunnySaintEddie", "res://scenes/file_explorer/pictures/devEdwina.png")
	
	#var steg_data: StegData = load(
		#"res://tasks/steg/steg_tutorial.tres")
	
	var file := FileSystem.get_file_entity(FileSystem.PICTURE_DIR + "/saintSofelin")
	file.metadata["type"] = "image"
	#file.metadata["Author"] = steg_data.author
	#file.metadata["Software"] = steg_data.software
	#file.metadata["Comment"] = steg_data.comment
	#file.metadata[steg_data.flag_metadata_key] = steg_data.flag
	
