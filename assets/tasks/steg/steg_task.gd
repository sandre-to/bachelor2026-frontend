extends BaseTask


func _ready() -> void:
	super()
	
	var file:= TextFile.new("HEI.txt")
	file.update_content("FLAGGET ER HER >:)))")
	file.metadata["hemmelig-data"] = "ctf{ FLAGG }"
	
	(FileSystem.get_file_entity("/home/documents") as Directory).insert_into(file)

	task = TaskData.new(0, "HIHI", TaskData.TaskType.STEGANO, "HAHA DRIT MORSOM OPPGAVE")
