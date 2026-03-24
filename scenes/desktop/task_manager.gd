class_name TaskManager extends Control

const CRYPTO_TASK_1: PackedScene = preload(
	"res://assets/tasks/crypto/crypto_task.tscn")

@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

var current_task: BaseTask = null

func _ready() -> void:
	missions_panel.hide()

func _on_task_button_pressed() -> void:
	if missions_panel.visible:
		fade_out(missions_panel)
	else:
		if current_task:
			fade_out(current_task)
			current_task = null
		fade_in(missions_panel)

func fade_in(panel: Control) -> void:
	panel.visible = true
	panel.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)

func fade_out(panel: Control) -> void:
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): panel.hide())

func _on_task_1_pressed() -> void:
	fade_out(missions_panel)
	
	var task := CRYPTO_TASK_1.instantiate()
	current_task = task
	add_child(task)
	task.global_position += Vector2(-80, 0)
	fade_in(task)

func _on_task_2_pressed() -> void:
	fade_out(missions_panel)

func _on_task_3_pressed() -> void:
	fade_out(missions_panel)
