class_name CustomWindow extends Window

var current_scene: PackedScene = null

func initialize(scene: PackedScene) -> void:
	current_scene = scene
	var instance = current_scene.instantiate()
	if instance == null: return
	add_child(instance)

func _on_close_requested() -> void:
	queue_free()
