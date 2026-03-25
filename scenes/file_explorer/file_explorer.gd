class_name FileExplorer extends Control

# Konstanter for å unngå skrivefeil
const PICTURES: String = "Pictures"
const DOCUMENTS: String = "Documents"
const SECRET: String = "Secret"

@onready var files: ItemList = %Files
@onready var folders_list: VBoxContainer = %FoldersList
@onready var preview: TextureRect = $Preview
@onready var title: Label = %Title

var file_system = {
	"Pictures": [] as Array[FakeFile],
	"Documents": [] as Array[FakeFile],
	"Secret": [] as Array[FakeFile]
}

func _ready() -> void:
	hide()
	
	#var cat := FakeFile.new()
	#cat.name = "cat"
	#cat.type = "IMAGE"
	#cat.path = "res://scenes/file_explorer/pictures/cat.jpg"
	#file_system[PICTURES].append(cat)
	#
	#var text_file := FakeFile.new()
	#text_file.name = "todo list"
	#text_file.type = "TEXT"
	#text_file.path = "Unknown"
	#file_system[DOCUMENTS].append(text_file)
	#
	#var secret := FakeFile.new()
	#secret.name = "password list"
	#secret.type = "TEXT"
	#secret.path = "Unknown"
	#file_system[SECRET].append(secret)
	
func _show_folder(folder: String) -> void:
	# Rydd bort forrige filer
	files.clear()
	title.text = folder
	
	for file in file_system[folder]:
		files.add_item(file.name)
		files.set_item_metadata(files.item_count - 1, file)
	
func _on_pictures_button_pressed() -> void:
	preview.hide()
	_show_folder(PICTURES)

func _on_documents_button_pressed() -> void:
	preview.hide()
	_show_folder(DOCUMENTS)

func _on_secret_button_pressed() -> void:
	preview.hide()
	_show_folder(SECRET)

func _on_files_item_selected(index: int) -> void:
	var file: FakeFile = files.get_item_metadata(index)
	print("Valgt fil: %s Type: %s" % [file.name, file.type])
