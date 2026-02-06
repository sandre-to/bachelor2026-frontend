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
	fs.mkdir("/home/bigsoda/dir_with.extention")
	print(fs.exists("/home/bigsoda/dir_with.extention"))
