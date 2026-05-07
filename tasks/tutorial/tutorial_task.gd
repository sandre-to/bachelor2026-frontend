class_name TutorialTask extends BaseTask

var type: String

func start() -> void:
	_on_start()


func set_data_info(key: String) -> void:
	pass

func _on_confirm_button_pressed() -> void:
	if enter_flag.text == task.flag:
		confirm_button.disabled = true
		SignalBus.task_completed.emit(type)
	else:
		error_panel.show()


@warning_ignore("unused_parameter")
func _on_hint_pressed(index: int) -> void:
	print("keine hint ;(")
