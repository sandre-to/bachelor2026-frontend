extends PacketData
class_name RawResponse

# RawResponse:
# Denne klassen representerer en rå nettverksrespons.
# Basically en wrapper for String :)

var raw_string: String

func _init(_raw_string: String) -> void:
	raw_string = _raw_string
	
func _to_string() -> String:
	return raw_string

func get_type() -> String:
	return "Raw"
