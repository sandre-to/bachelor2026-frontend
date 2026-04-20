class_name TutorialTasks extends Control

const TASK_1: PackedScene = preload(
	"res://tasks/crypto/crypto_task.tscn")

@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

@onready var task_1: Button = %Task1
var current_task: BaseTask = null

func _ready() -> void:
	missions_panel.hide()
		
func _on_task_button_pressed() -> void:
	if missions_panel.visible:
		fade_out(missions_panel)
	else:
		if current_task:
			fade_out(current_task)
		fade_in(missions_panel)

func fade_in(panel: Control) -> void:
	panel.visible = true
	panel.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.25)

func fade_out(panel: Control) -> void:
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.25)
	tween.tween_callback(func(): panel.hide())

func _on_task_1_pressed() -> void:
	spawn_task(TASK_1)
	
func spawn_task(task_scene: PackedScene) -> void:
	fade_out(missions_panel)
	
	var task := task_scene.instantiate() as CryptoScene
	add_child(task)
	task.set_data_info("tutorial_task")
	current_task = task
	task.global_position += Vector2(-80, 0)
	fade_in(task)
