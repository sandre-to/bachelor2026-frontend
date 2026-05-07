class_name TaskData 
extends Resource

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB,
}

@export var type: TaskType
@export var name: String = "" 
@export var completed: bool = false
@export var flag: String = ""
@export_multiline() var description: String = ""
@export_multiline() var puzzle_text: String = ""
