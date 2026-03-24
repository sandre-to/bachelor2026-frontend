extends Node

func _ready() -> void:
	
	# Notater (Kristoffer): 
	#	- Jeg hater "current_path" ideen, helt yalla.
	#	  Et alternativ kan være å implementere at
	#	  kataloger returneres til API-brukeren slik
	#	  at de kan bruke funksjonene rett på dem.
	#	  Det er mer effektivt med tanke på ytelse og
	#	  lesbarhet ig. Eller skal vi bare ha alt være
	#	  absoluttstier? Spilleren skal jo ikke bruke
	#	  API-et direkte, sikkert lettere for appene også.
	
	var fs: FileSystem = FileSystem.new()

	fs.mkdir("/home")
	fs.mkdir("/home/bigsoda")
	fs.mkdir("/home/bigsoda/lol")
	fs.mkdir("/home/bigsoda/lol/omg")
	
	var dir: Directory = fs.get_file_entity("/home/bigsoda")
	print(dir)
	
	var sub_dir: Directory = dir.get_entity("")
	print(sub_dir)
	
	fs.touch("/home/bigsoda/file.txt")
	print(sub_dir)
	
