extends Node


func _ready() -> void:
	NetworkManager.connect_to_backend()
	NetworkManager.message_received.connect(_on_message)
	NetworkManager.send("task-info", {"taskID": 0})
	
func _on_message(msg: Dictionary) -> void:
	print("Type:   ", msg.get("type"))
	print("Status: ", msg.get("status"))
	print("Data:   ", msg.get("data"))
