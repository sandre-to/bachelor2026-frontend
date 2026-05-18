class_name TaskData 
extends Resource

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB,
}

@export var type: TaskType
@export var id: int
@export var name: String = "" 
@export var completed: bool = false
@export var flag: String = ""
@export_multiline() var description: String = ""
@export_multiline() var puzzle_text: String = ""

# Felt hentet av backenden #
@export var backend_data: Dictionary = {}
@export_multiline() var extra_description: String = ""
var hint_costs: Array[float] = []
