extends Resource
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

var _method: Method
var _content: Dictionary

func _init(method: Method, content: Dictionary) -> void:
	_method = method
	_content = content


func get_method() -> String:
	return method_str[_method]
	
func get_content() -> Dictionary:
	return _content
