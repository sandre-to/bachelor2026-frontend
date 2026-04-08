extends Node


func _ready() -> void:
	
	# Filsystemet er globalt, bare: FileSystem.*funksjon* for å samhandle med det.
	#
	# Først litt om entitetene i filsystemet:
	# 
	# Filsystemet består av filentiteter som vil si, filer og kataloger. Disse filentitetene
	# er IKKE noe godot har fra før av, men noe jeg har skapt; de er objekter i spillet.
	# Se filene -> globals/file_system/entities/
	#
	# Klassen "FileEntity" er en abstrakt klasse "File" og "Directory" arver fra.
	# FileEntity har attributtene navn og rettigheter (lese, skrive og kjøre).
	# Den har også funksjonene:
	# - get_user_rights():	Viser brukerrettigheter
	# - chmod():			Endrer brukerrettigheter
	# - get_entity():		Henter en filentitet under denne entiteten
	#
	# Klassen "File" er akuratt nå ganske bar, det eneste feltet den har er "text_content",
	# som inneholder tekst; alle filer er tekstfiler tihi, dette kan du endre om du trenger!!! 
	# 
	# Klassen "Directory" er mye større, men det værste er internt / privat.
	# Den har to attributter: parent_dir (forelderkatalog) og _content (tabell med filentiteter)(er intern).
	# Funksjonene burde forklare seg selv:
	# - ls():				Gir en string med navnene på filentitetene i katalogen.
	# - entity_exists():	Sjekker om en entitet med et gitt navn eksisterer.
	# - insert_into():		Tar en filentitet og setter den inn i katalogen.
	# - get_entity():		Henter ut en entitet fra katalogen. Denne funksjonen tar inn en RELATIV filsti
	#						fra denne katalogen og kan hente filentiteter i underkataloger.
	
	# Hvis du skal lage kataloger 
	FileSystem.mkdir("/home")
	FileSystem.mkdir("/bin")
	FileSystem.mkdir("/etc")
	
	# Hvis du skal lage nye filer
	FileSystem.touch("/home/filnavn.txt")
	FileSystem.touch("/home/sus_fil.txt")
	FileSystem.touch("/etc/loll.txt")
	
	# Hvis du skal hente en filentitet
	# Husk at dette returnerer en filentitet og IKKE en File eller Directory;
	# du må caste det som en fil:
	var fil_entitet: FileEntity = FileSystem.get_file_entity("/home/filnavn.txt")
	var fil: File = fil_entitet as File
	fil.text_content = "innhold tihi"
	print(fil.text_content)

	# Hent en katalog
	var fil_entitet_2: FileEntity = FileSystem.get_file_entity("/home")
	var dir: Directory = fil_entitet_2 as Directory
	print(dir.ls())
	
	# Når du har hentet ut en katalog som over, kan du sette inn filentiteter direkte:
	var ny_fil: File = File.new("kul_fil.txt")
	dir.insert_into(ny_fil)

	print(
		(FileSystem.get_file_entity("/home") as Directory).ls()
	)
