extends BaseTask


func _ready() -> void:
	super()
	var file:= TextFile.new("HEI.txt")
	file.update_content("DETTE ER FLAGGET >:))) CTF{ FLAGG }")
	(FileSystem.get_file_entity("/home/documents") as Directory).insert_into(file)
