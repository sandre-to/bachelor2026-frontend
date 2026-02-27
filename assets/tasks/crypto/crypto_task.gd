class_name CryptoTask extends BaseTask

var hovering: bool = false
var drag_offset: Vector2

func _enter_tree() -> void:
	task_type = TaskType.CRYPTO
	
func _process(delta: float) -> void:
	if hovering:
		if Input.is_action_pressed("left_click"):
			global_position = get_global_mouse_position() + drag_offset
		elif Input.is_action_just_released("left_click"):
			hovering = false

func _on_close_button_pressed() -> void:
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	hovering = true
	drag_offset = global_position - get_global_mouse_position()

func _on_area_2d_mouse_exited() -> void:
	hovering = false
