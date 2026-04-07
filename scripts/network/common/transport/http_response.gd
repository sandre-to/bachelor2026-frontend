extends PacketData
class_name HttpResponse

# HttpResponse:
# Et objekt som representerer en HTTP-response

var _response_code: int = 200
var _content: Dictionary


func _init(response_code: int, content: Dictionary) -> void:
	_response_code = response_code
	_content = content


func get_response_code() -> int:
	return _response_code
	
func get_content() -> Dictionary:
	return _content

func _to_string() -> String:
	return "Response Code: " + str(_response_code) + "\n" + str(_content)	

func get_type() -> String:
	return "HTTP Response"
