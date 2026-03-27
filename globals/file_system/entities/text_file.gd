extends File
class_name TextFile

# Tekstinnholdet
var content: String

func _to_string() -> String:
	return name + ": text-file, " + "Rights: " + get_user_rights()
