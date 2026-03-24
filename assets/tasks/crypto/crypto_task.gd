class_name CryptoTask extends BaseTask

func _ready() -> void:
	super._ready()
	set_task_info()

func set_task_info() -> void:
	title.text = task.name
	description.text = task.description
	puzzle.text = task.cipher_text

func validate_flag() -> bool:
	return enter_flag.text == task.flag

func _on_confirm_button_pressed() -> void:
	if validate_flag():
		print("that is true!")
