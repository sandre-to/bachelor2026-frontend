extends FileEntity
class_name File

# File:
# Et objekt som representerer en fil

# Notater:
# - Trenger metadatafelt for steganografioppgaver

# Rettighet: Kjørbar
var exec: bool = false

# Metadata om filen (brukes i oppgaver)
var _metadata: String

# Midlertidig en tekstfil :)
var _text_content: String


func _init(_name: String, _parent_system: FileSystem) -> void:
	super(_name, _parent_system)


# Update_content():	 Oppdaterer innholdet
func update_content(content: String) -> void:
	_text_content = content

# Update_metadata(): Oppdaterer metadataen
func update_metadata(metadata: String) -> void:
	_metadata = metadata

func get_content() -> String:
	return _text_content

# Get_entity(): Gir filen.
func get_entity(path: String) -> FileEntity:
	return self


func _to_string() -> String:
	return name
