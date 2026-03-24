class_name BaseTask extends Control

@export var task: TaskData = null

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var puzzle: RichTextLabel = %Puzzle
@onready var enter_flag: LineEdit = %EnterFlag

func _ready() -> void:
	if not task:
		push_error("Missing task resource. Please add one.")

# Override denne funksjonen i de ulike oppgavene
func set_task_info() -> void:
	pass

func _on_hint_1_pressed() -> void:
	pass # Replace with function body.

func _on_hint_2_pressed() -> void:
	pass # Replace with function body.

func _on_hint_3_pressed() -> void:
	pass # Replace with function body.

func _on_enter_flag_text_submitted(new_text: String) -> void:
	pass # Replace with function body.

func _on_confirm_button_pressed() -> void:
	pass # Replace with function body.
