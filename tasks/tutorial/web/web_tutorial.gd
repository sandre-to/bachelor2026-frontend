class_name WebTutorial extends TutorialTask

func _on_start() -> bool:
	type = "web"
	title.text = task.name
	description.text = task.description
	task.flag = task.flag
	task.password = task.password
	SignalBus.send_web_data.emit(task)
	return true
