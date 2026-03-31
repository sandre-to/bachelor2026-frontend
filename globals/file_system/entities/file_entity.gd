@abstract
extends Resource
class_name FileEntity

# Identitet
var name: String

# Rettigheter
var read: bool	= true
var write: bool	= true
var exec: bool  = false

var metadata: Dictionary = {}
const MIN_FILE_SIZE_BYTES = 64

func _init(_name: String) -> void:
	self.name = _name
	metadata["size"] = MIN_FILE_SIZE_BYTES


@abstract
# Get_entity():	Returnerer en entity i filsystemet, starter fra denne katalogen.
#				Man kan bruke en relativ filsti fra denne katalogen. Kan feile dersom:
#						- Man prøver å hoppe en katalog tilbake fra root-katalogen (ENOENT).
#						- Om man ikke har lesetilgang (EACCES).
#						- Om entiteten ikke eksisterer (ENOENT).
func get_entity(path: String) -> FileEntity


# Get_user_rights():	Gir en string som representerer rettighetene til brukeren.
func get_user_rights() -> String:
	var user_rights: String = "---"
	if read:
		user_rights.replace_char(0, "r".unicode_at(0))
	if write:
		user_rights.replace_char(1, "w".unicode_at(0))
	if exec:
		user_rights.replace_char(2, "x".unicode_at(0))
	return user_rights


# Chmod():	En metode som etterligner chmod.
func chmod(input: String) -> bool:
	if input.length() != 3:
		return false

	read  = true if input[0] == "r" else false
	write = true if input[1] == "w" else false
	exec  = true if input[2] == "x" else false
	
	return true
