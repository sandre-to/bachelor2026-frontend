class_name StegData
extends TaskData

@export var image_name: String = ""
@export_file("*.jpg", "*.jpeg", "*.png", "*.webp") var real_image_path: String = ""
@export var virtual_directory: String = "/home/pictures"

@export var flag_metadata_key: String = "UserComment"

@export var author: String = ""
@export var software: String = "BunOS Image Exporter"
@export var comment: String = "Look closer"

func apply_to_filesystem() -> bool:
	var full_path := virtual_directory.path_join(image_name)
	var existing := FileSystem.get_file_entity(full_path)

	if existing != null:
		existing.metadata["type"] = "image"
		existing.metadata["Author"] = author
		existing.metadata["Software"] = software
		existing.metadata["Comment"] = comment
		existing.metadata[flag_metadata_key] = flag
		return true

	var image_file := ImageFile.new(image_name, real_image_path)
	image_file.metadata["type"] = "image"
	image_file.metadata["Author"] = author
	image_file.metadata["Software"] = software
	image_file.metadata["Comment"] = comment
	image_file.metadata[flag_metadata_key] = flag

	var target_dir := FileSystem.get_file_entity(virtual_directory) as Directory
	if target_dir == null:
		push_error("Fant ikke katalogen: " + virtual_directory)
		return false

	target_dir.insert_into(image_file)
	return true
