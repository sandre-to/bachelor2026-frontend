extends Node

func _ready() -> void:
	FileSystem.mkdir("/home")
	FileSystem.touch("/home/testfile.txt")
	print(FileSystem.get_file_entity("/home/testfile.txt"))
