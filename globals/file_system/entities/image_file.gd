extends File
class_name ImageFile

var _real_path: String				# Den REELE filstien til bildet
var texture: Texture2D = null


func _init(_name: String, real_path: String) -> void:
	super(_name)
	_real_path = real_path
	metadata["type"] = "image"



func get_texture() -> Texture2D:
	if texture == null:
		load_image()
	return texture
	


func load_image() -> void:
	if not ResourceLoader.exists(_real_path):
		push_error("Image does not exist: " + _real_path)
		return

	texture = load(_real_path) as Texture2D

	if texture == null:
		push_error("Failed to load texture: " + _real_path)
