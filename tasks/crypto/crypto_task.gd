class_name CryptoScene extends BaseTask

@export var crypto_tasks := {
	"tutorial": "res://tasks/crypto/tutorial_task.tres",
	"1.1": "res://tasks/crypto/level1-1.tres",
	"1.4": "res://tasks/crypto/level1-4.tres"
}

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
	SignalBus.sent_message.emit(task.backend_data["message"] + task.backend_data["flag"], 3)
	return true

func _on_copy_button_pressed() -> void:
	DisplayServer.clipboard_set(puzzle.text)

func _on_button_pressed() -> void:
	hint_box.hide()

#func _on_confirm_button_pressed() -> void:
	#if enter_flag.text == task.flag:
		#confirm_button.disabled = true
		#SignalBus.task_completed.emit()
	#else:
		#error_panel.show()

func set_task(_task: CryptoData) -> void:
	task = _task
	title.text = _task.name
	description.text = _task.description
	puzzle.text = _task.cipher_text

func load_resource(key: String) -> void:
	task = load(crypto_tasks[key])
