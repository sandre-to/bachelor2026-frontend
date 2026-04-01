extends RefCounted
class_name HttpResponse

# HttpResponse:
# Et objekt som representerer en HTTP-response

var _response_code: int

func _init(response_code: int) -> void:
	_response_code = response_code
	
func get_response_code() -> int:
	return _response_code
