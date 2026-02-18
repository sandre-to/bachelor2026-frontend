class_name CustomWindow extends Window

var current_scene: PackedScene = null

func _ready() -> void:
	if current_scene:
		add_child(current_scene.instantiate())

func _on_close_requested() -> void:
	queue_free()
