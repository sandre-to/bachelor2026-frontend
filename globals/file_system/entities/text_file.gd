extends File
class_name TextFile

# Tekstinnholdet
var _content: String


func _init(_name: String) -> void:
	super(_name)
	metadata["type"] = "text-file"



func update_content(content: String) -> void:
	_content = content
	metadata["size"] = MIN_FILE_SIZE_BYTES + _content.length()



func get_content() -> String:
	return _content



func _to_string() -> String:
	return name + ": text-file, " + "Rights: " + get_user_rights()
