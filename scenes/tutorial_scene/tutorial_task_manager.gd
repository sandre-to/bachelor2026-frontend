class_name TutorialTasks extends Control

const TASK: PackedScene = preload("res://tasks/base_task.tscn")
const TASK_KEY: String = "tutorial"
const CRYPTO: int = 0
const STEG: int = 1
const WEB: int = 3

@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3

var current_task: BaseTask = null

func _ready() -> void:
	missions_panel.hide()
	SignalBus.task_completed.connect(_on_task_completed)
		
func clear_current_task() -> void:
	if current_task:
		current_task.queue_free()
		current_task = null
		
func _on_task_button_pressed() -> void:
	if current_task and current_task.visible:
		fade_out(current_task)
		return

	if missions_panel.visible:
		fade_out(missions_panel)
	else:
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
	spawn_task(CRYPTO)

func _on_task_2_pressed() -> void:
	spawn_task(STEG)
	
func _on_task_3_pressed() -> void:
	spawn_task(WEB)

func spawn_task(index: int) -> void:
	if current_task:
		current_task.queue_free()
		current_task = null
	
	fade_out(missions_panel)
	
	var task := TASK.instantiate()
	add_child(task)
	
	task.set_data_info(TASK_KEY, index)
	current_task = task
	
	task.global_position += Vector2(-100, 0)
	fade_in(task)

func _on_task_completed() -> void:
	fade_out(current_task)
