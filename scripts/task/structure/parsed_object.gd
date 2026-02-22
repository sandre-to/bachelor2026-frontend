extends RefCounted
class_name ParsedObject

# ParsedObject:
# Dette er en midlertidig datastruktur for et parset objekt.
# Brukes kun under parsingen av en oppgave.


# Navnet på objektet referert av oppgaven
var name: String

# Typen på objektet
var type: String

# Selve objektet som ble parset ut
var parsed_object: Variant

# En liste over barneobjekter dette objektet eier
var children: Array = []


func _init(_name: String, _type: String) -> void:
	name = _name
	type = _type
	children = []


# Has_children():	Returnerer en bool basert på om objektet har barn.
func has_children() -> bool:
	return children.size() != 0
