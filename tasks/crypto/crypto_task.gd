class_name CryptoScene extends BaseTask

func _ready() -> void:
	super._ready()
	error_panel.hide()
	hint_box.hide()
	
	SignalBus.encrypted.connect(func(message):
		title.text = task.name
		description.text = task.description
		puzzle.text = message
		)

func _on_start() -> bool:
	SignalBus.sent_message.emit(task.backend_data["message"], 3)
	return true

func _on_copy_button_pressed() -> void:
	DisplayServer.clipboard_set(puzzle.text)

func _on_button_pressed() -> void:
	hint_box.hide()
