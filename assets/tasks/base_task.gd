class_name BaseTask extends Control

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB
}

@export var task_type: TaskType
