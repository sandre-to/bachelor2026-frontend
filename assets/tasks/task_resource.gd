class_name TaskData extends Resource

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB_EXPLOIT
}

@export var id: String
@export var type: TaskType
@export var name: String = "" 
@export var completed: bool = false
@export_multiline() var description: String = ""
