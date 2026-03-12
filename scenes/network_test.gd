extends Node


func _ready() -> void:
	NetworkManager.connect_to_backend()
	NetworkManager.send("task-info", {"taskID": 0})
	
	pass
