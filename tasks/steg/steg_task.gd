extends BaseTask
class_name StegTask

func _ready() -> void:
	super()
	
	# Lag en tom fil
	var file_with_flag: File = File.new("mega-fil.txt")
	
	title.text = task.name
	description.text = task.description
	# Sett metadatafeltet "super-hemmelig" til data hentet fra backenden
	#file_with_flag.metadata["super-hemmelig"] = task.dynamic_data["flagget"]
	
	# Putt filen inn i filsystemet på stien: "/home/documents". 
	(FileSystem.get_file_entity("/home/documents") as Directory).insert_into(file_with_flag)

# mini preview bilde, som en knapp. de trykker den twice så kommer 
# bilde opp stort, egen scene. filsti på "baren" på bilde vindu
# metadata vil være hardkodet med dynamisk flagg variabel
