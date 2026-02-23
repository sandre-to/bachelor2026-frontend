extends PacketData
class_name HttpReq

# HttpReq(uest):
# Denne klassen er en representasjon av en HTTP-forespørsel.
# Vi kaller klassen HttpReq fordi HttpRequest er en klasse fra før av.

enum Method{
	GET,
	POST,
	PUT,
	DELETE
}
const method_str: Dictionary[Method, String] = {
	Method.GET: "GET",
	Method.POST: "POST",
	Method.PUT: "PUT",
	Method.DELETE: "DELETE"
}

var _method: String
var _content: Dictionary

func _init(method: String, content: Dictionary) -> void:
	_method = method
	_content = content


func get_method() -> String:
	return _method
	
func get_content() -> Dictionary:
	return _content

func _to_string() -> String:
	return str(_content)

func get_type() -> String:
	return "HTTP Request"
