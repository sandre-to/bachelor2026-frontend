extends Button

var tween: Tween

func _ready() -> void:
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.4)
	tween.tween_property(self, "modulate", Color.AQUAMARINE, 0.05)

func _on_mouse_exited() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
