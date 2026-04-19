extends Control
class_name ImagePopUp

@onready var bg: ColorRect = $ColorRect
@onready var image_rect: TextureRect = $CenterContainer/VinduPanel/TextureRect
@onready var close_button: Button = $CloseButton
@onready var panel: Panel = $CenterContainer/VinduPanel

func _ready() -> void:
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	image_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func show_image(texture: Texture2D) -> void:
	if texture == null:
		push_error("Ingen texture sendt til ImagePopUp")
		return
	
	image_rect.texture = texture
	
	var img_size: Vector2 = texture.get_size()
	
	var min_size := Vector2(700, 800)
	var max_size := Vector2(1000, 900)
	var padding := Vector2(20, 20)
	
	var panel_size := img_size + padding
	panel_size.x = clamp(panel_size.x, min_size.x, max_size.x)
	panel_size.y = clamp(panel_size.y, min_size.y, max_size.y)
	
	panel.custom_minimum_size = panel_size
	panel.size = panel_size
	
	# Fyll hele panelet, men med 10px kant
	image_rect.position = Vector2(10, 10)
	image_rect.size = panel_size - Vector2(20, 20)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		queue_free()

func _on_close_button_pressed() -> void:
	queue_free()

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		queue_free()
