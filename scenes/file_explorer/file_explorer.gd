class_name FileExplorer extends Control

# TODO:
# 1:	Programmer for å åpne filer:
#		-	Teksteditor
#		-	Imageviewer
# 2:	UI i filexploreren:
#		-	Et sted å kunne skrive inn filstier
#		-	Navigasjonsknapper (<-) & (->)
#		-	Funksjonalitet for å pinne nye faste kataloger på siden
#		-	Ikoner ved siden av filoppføringene
# 3:	Feilhåndtering


# Den aktive katalogen (Current Working Directory)
var cwd: Directory

@onready var files: ItemList = %Files
@onready var folders_list: VBoxContainer = %FoldersList
@onready var preview: TextureRect = $Preview



func _ready() -> void:
	cwd = FileSystem.get_file_entity("/")
	hide()

	
func _show_folder_from_path(path: String) -> void:
	_show_folder(
		FileSystem.get_file_entity(path) as Directory
	)
	
func _show_folder(directory: Directory) -> void:
	# Rydd bort tidligere filer
	files.clear()
	
	cwd = directory
	for file in cwd.content:
		files.add_item(file.name)
		files.set_item_metadata(files.item_count - 1, file)

	
	
func _on_pictures_button_pressed() -> void:
	preview.hide()
	_show_folder_from_path(FileSystem.PICTURE_DIR)

func _on_documents_button_pressed() -> void:
	preview.hide()
	_show_folder_from_path(FileSystem.DOCUMENT_DIR)

func _on_secret_button_pressed() -> void:
	preview.hide()
	_show_folder_from_path(FileSystem.SECRET_DIR)



func _on_files_item_selected(index: int) -> void:
	var file: FileEntity = files.get_item_metadata(index)
	print("Valgt fil: %s" % [file.name])



# _on_files_item_activated():	Kjøres når en valgt fil/katalog åpnes.
#								Den bestemmer hvilke "program" filen skal åpnes i.
func _on_files_item_activated(index: int) -> void:
	var file_entity: FileEntity = files.get_item_metadata(index)
	
	
	if file_entity is TextFile:
		print((file_entity as TextFile).get_content())
		#var file_file = preload("res://scenes/file_explorer/fileView.tscn")
		#add_child(file_file.instantiate())
		
	#elif file_entity is ImageFile:
		#var image_file = preload("res://scenes/file_explorer/pictureView.tscn")
		#add_child(image_file.instantiate())
	
	elif file_entity is Directory:
		_show_folder(file_entity as Directory)
	
	#if file.type == "IMAGE":
		#var texture := load(file.path)
		#preview.texture = texture
		#preview.show()
