extends BaseTask
class_name ExpTask

var sus_file: TextFile

func _on_start() -> bool:
	
	# Lag fil (med flagg)
	sus_file = TextFile.new("megafil.txt")
	sus_file.metadata["flagg"] = "dette er flagget ass: " + task.backend_data["flagg"]
	sus_file.update_content(task.backend_data["filinnhold"])
	
	FileSystem.insert_into(FileSystem.DOCUMENT_DIR, sus_file)
	
	return true
