class_name TutorialTask extends BaseTask

var type: String

func start() -> void:
	_on_start()


func set_data_info(key: String, index: int) -> void:
	pass

func _on_confirm_button_pressed() -> void:
	if enter_flag.text == task.flag:
		confirm_button.disabled = true
		SignalBus.task_completed.emit(type)
		print("fsd")
	else:
		error_panel.show()



func _on_enter_flag_text_submitted(_new_text: String) -> void: 
	_on_confirm_button_pressed()



@warning_ignore("unused_parameter")
func _on_hint_pressed(index: int) -> void:
	print("keine hint ;(")
