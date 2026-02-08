extends FileEntity
class_name File

# File:
# Et objekt som representerer en fil

# Notater:
# - Trenger metadatafelt for steganografioppgaver

# Rettighet: Kjørbar
var exec: bool = false

# Midlertidig en tekstfil :)
var text_content: String


func _init(_name: String, _parent_system: FileSystem) -> void:
	super(_name, _parent_system)


# Get_entity(): Gir filen.
func get_entity(path: String) -> FileEntity:
	return self


func _to_string() -> String:
	return name
