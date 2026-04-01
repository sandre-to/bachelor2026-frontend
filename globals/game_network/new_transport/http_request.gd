extends RefCounted
class_name HttpReq

# HttpReq(uest):
# Denne klassen er en representasjon av en HTTP-forespørsel.
# Vi kaller klassen HttpReq fordi HttpRequest er en klasse fra før av.

var _method: String

func _init(method: String) -> void:
	_method = method.to_upper()

func get_method() -> String:
	return _method
