class_name CryptoTask extends BaseTask

func _ready() -> void:
	super._ready()
	set_task_info()

func set_task_info() -> void:
	title.text = task.name
	description.text = task.description
	puzzle.text = task.cipher_text

func _on_confirm_button_pressed() -> void:
	if validate_flag(enter_flag.text):
		completed_task()

func _on_enter_flag_text_submitted(new_text: String) -> void:
	if validate_flag(new_text):
		completed_task()

func completed_task() -> void:
	super.completed_task()

func validate_flag(input: String) -> bool:
	return input == task.flag

func _on_hint_pressed(index: int) -> void:
	match index:
		1:
			description.text = "Find a tool that deciphers this."
		2:
			description.text = "Try out different numbers in the shift bar (1 - 9)."
		3:
			description.text = "There is one word in the paragraph that stands out."
