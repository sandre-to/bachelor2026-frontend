class_name TutorialTasks extends Control

const CRYPTO_TASK: PackedScene = preload(
	"res://tasks/crypto/crypto_task.tscn")
const STEGANO_TASK: PackedScene = preload(
	"res://tasks/steg/steg_task.tscn")
const WEB_TASK: PackedScene = preload(
	"res://tasks/web_exploit/web_task.tscn")

@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3

var current_task: BaseTask = null

func _ready() -> void:
	missions_panel.hide()
		
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
	spawn_task(CRYPTO_TASK, "tutorial_task", "crypto")


func _on_task_2_pressed() -> void:
	spawn_task(STEGANO_TASK, "tutorial_task", "steg")
	var task := current_task
	if task:
		var hint_container = task.get_node("OuterPanel/MarginContainer/InnerPanel/VBoxContainer/HintContainer")
		hint_container.hide()
	
func _on_task_3_pressed() -> void:
	spawn_task(WEB_TASK, "tutorial_task", "web")
	var task := current_task
	if task:
		var hint_container = task.get_node("OuterPanel/MarginContainer/InnerPanel/VBoxContainer/HintContainer")
		hint_container.hide()

func spawn_task(task_scene: PackedScene, key: String, task_type: String) -> void:
	if task_scene == null:
		return

	if current_task:
		current_task.queue_free()
		current_task = null
	fade_out(missions_panel)
	
	var task := task_scene.instantiate()
	add_child(task)
	
	task.task_type = task_type
	task.set_data_info(key)
	current_task = task
	
	task.global_position += Vector2(-100, 0)
	fade_in(task)
	task.start()
