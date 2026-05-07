class_name StegScene 
extends BaseTask

func _on_start() -> bool:
	var steg_task := task as StegData
	if steg_task == null:
		push_error("Task is not StegData")
		return false

	var full_path := steg_task.virtual_directory.path_join(steg_task.image_name)
	var existing := FileSystem.get_file_entity(full_path)

	if existing != null:
		print("FOUND EXISTING FILE:", full_path)
		
		existing.metadata["type"] = "image"
		existing.metadata["Author"] = steg_task.author
		existing.metadata["Software"] = steg_task.software
		existing.metadata["Comment"] = steg_task.comment
		existing.metadata[steg_task.flag_metadata_key] = steg_task.flag

		return true

	var image_file := ImageFile.new(
		steg_task.image_name,
		steg_task.real_image_path
	)

	image_file.metadata["type"] = "image"
	image_file.metadata["Author"] = steg_task.author
	image_file.metadata["Software"] = steg_task.software
	image_file.metadata["Comment"] = steg_task.comment
	image_file.metadata[steg_task.flag_metadata_key] = steg_task.flag

	print("NEW FILE METADATA:", image_file.metadata)

	var target_dir := FileSystem.get_file_entity(steg_task.virtual_directory) as Directory
	if target_dir == null:
		push_error("Fant ikke katalogen: " + steg_task.virtual_directory)
		return false

	target_dir.insert_into(image_file)

	var inserted := FileSystem.get_file_entity(full_path)
	print("INSERTED FILE:", inserted)
	if inserted != null:
		print("INSERTED METADATA:", inserted.metadata)

	return true

func _on_exit_button_pressed() -> void:
	error_panel.hide()
