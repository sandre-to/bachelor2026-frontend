class_name TaskData extends Resource

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB_EXPLOIT,
	BOSS
}

@export var id: int
@export var type: TaskType
@export var name: String = "" 
@export var completed: bool = false
@export_multiline() var description: String = ""

# Felt hentet av backenden #
@export var backend_data: Dictionary = {}
@export_multiline() var extra_description: String = ""
var hint_costs: Array[float] = []
