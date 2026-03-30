class_name TaskData extends Resource

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB_EXPLOIT
}

@export var id: int
@export var type: TaskType
@export var name: String = "" 
@export var completed: bool = false
@export_multiline() var description: String = ""




func _init(_id: int, _name: String, _type: TaskType, _desc: String) -> void:
	id = _id
	name = _name
	type = _type
	description = _desc
	
	var req_id: int = NetworkManager.send_own({
		"type": "task",
		"data": {
			"taskID": id
		}
	})
	
	var response: Dictionary = await NetworkManager.a
	
