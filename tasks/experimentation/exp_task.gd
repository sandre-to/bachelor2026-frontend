extends BaseTask
class_name ExpTask

var sus_file: TextFile

func _ready() -> void:
	task = TaskData.new(9, "EXPERIMENTATION", TaskData.TaskType.CRYPTO, "bitchass")
	await super.request_task()
	set_data_info()
	
	sus_file = TextFile.new("sus.txt")
	sus_file.metadata["flagg"] = "dette er flagget ass: " + task.backend_data["flagg"]
	FileSystem.insert_into(FileSystem.DOCUMENT_DIR, sus_file)
	
	await super.parse_finished()
	

func set_data_info() -> void:
	title.text = task.name
	description.text = task.description

func _on_confirm_button_pressed() -> void:
	print("SUBMIT")
	var req_id: int = Backend.send_own({
		"type": "validate-flag",
		"data": {
			"flag": enter_flag.text
		}
	})
	var response: Dictionary = await Backend.await_message(req_id)
	
	var result: String = response.get("data").get("result")
	if result == "correct":
		hide()
		print("YIPPI")
	else:
		print("bruh")
	
