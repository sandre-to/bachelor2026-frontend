class_name CryptoScene extends BaseTask

func _ready() -> void:
	super._ready()
	set_data_info()

func set_data_info() -> void:
	title.text = task.name
	description.text = task.description
	puzzle.text = task.cipher_text

func _on_hint_pressed(index: int) -> void:
	match index:
		1:
			description.text = "What kind of tool is needed for weird messages?"
		2:
			description.text = "Open the tools button"
		3:
			description.text = "Try with differet shift (1 - 9)"
			
func _on_confirm_button_pressed() -> void:
	if enter_flag.text == task.flag:
		print("nice")
		SignalBus.task_completed.emit()
