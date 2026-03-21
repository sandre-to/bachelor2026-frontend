extends Node


var task_requested: bool 	= false	# 1.
var task_ready: bool 		= false	# 2.

var task_parser: TaskParser = TaskParser.new()
var task: Task = Task.new(SPNetwork.new())


func _ready() -> void:
	NetworkManager.connect_to_backend()
	NetworkManager.message_received.connect(_on_message)


func _process(delta: float) -> void:
	
	if not task_requested:
		NetworkManager.send("task", {"taskID": 0})
		task_requested = true
		
	elif task_ready:
		task.start()
		task_ready = false
	
	
	
	
	
func task_msg_receivced(status: String, data: Dictionary):
	if status == "error":
		print(data)
		push_error("task_msg_receivced(): status")
		return
	
	task = task_parser.parse(
		JSON.stringify(data), task
	)
	
	if task_parser.get_error() != 0:
		NetworkManager.send_own({
			"type": "parse-status",
			"status": "error",
			"data": {
				"desc": task_parser.get_error_desc()
			}
		})
		push_error("task_msg_receivced(): parser")
		return
	
	NetworkManager.send_own({
		"type": "parse-status",
		"status": "success"
	})
	
	
	
	
func _on_message(msg: Dictionary) -> void:
	var type 	= msg.get("type")
	var status 	= msg.get("status")
	var data 	= msg.get("data")
	
	if type == "task":
		task_msg_receivced(status, data)
	elif type == "parse-status":
		task_ready = true
		
	
	
	pass
