class_name IntroScene extends Control

@onready var animation: AnimationPlayer = $Animation

func _on_start_button_pressed() -> void:
	animation.play("fade_out")
	
	await animation.animation_finished
	get_tree().change_scene_to_file(
		"res://scenes/desktop/desktop_environment.tscn")

func _on_tutorial_button_pressed() -> void:
	animation.play("fade_out")
	
	await animation.animation_finished
	get_tree().change_scene_to_file(
		"res://scenes/tutorial_scene/tutorial_scene.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
