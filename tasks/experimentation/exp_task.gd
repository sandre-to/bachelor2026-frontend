extends BaseTask
class_name ExpTask

var sus_file: TextFile

func _on_start() -> bool:
		
	sus_file = TextFile.new("sus.txt")
	sus_file.metadata["flagg"] = "dette er flagget ass: " + task.backend_data["flagg"]
	FileSystem.insert_into(FileSystem.DOCUMENT_DIR, sus_file)
	
	return true
