extends FileEntity
class_name File

# File:
# Et objekt som representerer en fil

# Notater:
# - Trenger metadatafelt for steganografioppgaver

# Midlertidig en tekstfil :)
var text_content: String

func _init(_name: String) -> void:
	super(_name)


@warning_ignore("unused_parameter")
# Get_entity():	Implementasjon av en abstrakte metode.
func get_entity(path: String) -> FileEntity:
	return self


func _to_string() -> String:
	return name + ": file, " + "Rights: " + get_user_rights()
