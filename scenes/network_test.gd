extends Node


var task_requested: bool 	= false	# 1.
var task_ready: bool 		= false	# 2.

var task_parser: TaskParser = TaskParser.new()
var task: Task = Task.new()


func _ready() -> void:
	NetworkManager.connect_to_backend()
	NetworkManager.message_received.connect(_on_message)
	print("-------------------------------------------")
	
	NetworkManager.send_own({
		"type": "task",
		"data": {
			"taskID": 0
		}
	})
	
	NetworkManager.send_own({
		"type": "parse-status",
		"status": "success"
	})
	
	NetworkManager.send_own({
		"type": "validate-flag",
		"data": {
			"flag": "feil flagg :("
		}
	})
	
	NetworkManager.send_own({
		"type": "validate-flag",
		"data": {
			"flag": "CTF{ LOLL DETTE ER FLAGGET ASS }"
		}
	})

	
	
func _on_message(msg: Dictionary) -> void:
	var type 	= msg.get("type")
	var status 	= msg.get("status")
	var data 	= msg.get("data")
	
	print(type)
	print(status)
	print(data)
	print()
	print("-------------------------------------------")
