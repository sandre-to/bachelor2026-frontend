extends File
class_name ImageFile

var _real_path: String				# Den REELE filstien til bildet
var image: Image = null
var texture: ImageTexture = null


func _init(_name: String, real_path: String) -> void:
	super(_name)
	_real_path = real_path



func get_texture() -> Texture2D:
	if texture == null:
		load_image()
	return texture
	


func load_image() -> void:
	if not FileAccess.file_exists(_real_path):
		push_error("fuckass bilde eksisterer ikke")
		return
	
	image = Image.new()
	var err = image.load(_real_path)
	if err != OK:
		push_error("fuckass bilde laster ikke")
		return
	
	texture = ImageTexture.create_from_image(image)
