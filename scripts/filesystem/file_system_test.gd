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

	fs.mkdir("/home", "/")
	fs.mkdir("/home/bigsoda", "/")
	fs.mkdir("/home/forsen", "/")
	
	fs.touch("/home/bigsoda/ballz", "/")
	(fs.get_file_entity("/home/bigsoda/ballz", "/") as File).text_content = "jump in MegaLUL"
	fs.cp("/home/bigsoda/ballz", "/home/forsen/file", "/")
	print(fs.exists("/home/bigsoda/ballz"))
	print(fs.exists("/home/forsen/file"))
