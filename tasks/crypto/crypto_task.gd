class_name CryptoScene extends BaseTask

var crypto_tasks := {
	"tutorial_task": "res://tasks/crypto/tutorial_task.tres",
	"level_1.1": "res://tasks/crypto/level1-1.tres",
	"level_1.4": "res://tasks/crypto/level1-4.tres"
}
@onready var error_panel: Panel = $ErrorPanel

func _ready() -> void:
	super._ready()
	error_panel.hide()

func set_data_info(key: String) -> void:
	if key in crypto_tasks.keys():
		var current_task = crypto_tasks[key]
		task = load(current_task)
		title.text = task.name
		description.text = task.description
		puzzle.text = task.cipher_text
	else:
		push_error("Key does not exist in tasks: ", key)
	
func _on_confirm_button_pressed() -> void:
	if enter_flag.text == task.flag:
		confirm_button.disabled = true
		completed_task()
		SignalBus.test.emit()
	else:
		error_panel.show()

func _on_exit_button_pressed() -> void:
	error_panel.hide()

func _on_copy_button_pressed() -> void:
	DisplayServer.clipboard_set(puzzle.text)
