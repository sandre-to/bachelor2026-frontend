@abstract
extends Resource
class_name TaskCMD

# TaskCMD:
# Dette er en abstakt klasse som beskriver en kommando 
# en oppgave kan utføre.

var params: Dictionary[String, Variant]

func _init(_params: Dictionary[String, Variant]) -> void:
	params = _params

@abstract
func execute() -> bool
