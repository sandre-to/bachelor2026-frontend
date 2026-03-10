extends Node

func _ready() -> void:
	var http: HTTPRequest = HTTPRequest.new()
	add_child(http)

	var url: String = "http://localhost:8080/api/task/TEST-TASK"
	http.request_completed.connect(_on_response)
	http.request(url)


	
	
func _on_response(result, response_code, headers, body) -> void:
	var parser: TaskParser = TaskParser.new()
	var task: Task = Task.new(SPNetwork.new())
	
	parser.parse(body.get_string_from_utf8(), task)
	task.start()
	task.network.devs_on_network()
	
