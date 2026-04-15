class_name TaskManager extends Control

const CRYPTO_TASK: PackedScene = preload(
	"res://tasks/crypto/crypto_task.tscn")

const STEGANO_TASK: PackedScene = preload(
	"res://tasks/experimentation/exp_task.tscn")
	
const WEB_TASK: PackedScene = preload(
	"res://tasks/web_exploit/web_task.tscn")
	
@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

# --- Oppgave knapper ---
@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3
@onready var task_4: Button = %Task4

func _ready() -> void:
	missions_panel.hide()
	
func _on_task_button_pressed() -> void:
	if missions_panel.visible:
		fade_out(missions_panel)
	else:
		close_tasks()
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
	spawn_task(CRYPTO_TASK)

func _on_task_2_pressed() -> void:
	spawn_task(STEGANO_TASK)
		
func _on_task_3_pressed() -> void:
	spawn_task(WEB_TASK)

func _on_task_4_pressed() -> void: 
	pass

func spawn_task(task_scene: PackedScene) -> void:
	if task_scene == null: return
	fade_out(missions_panel)
	
	var task := task_scene.instantiate()
	
	add_child(task)
	task.global_position += Vector2(-100, 0)
	fade_in(task)

func close_tasks() -> void:
	for child in get_children():
		if child is BaseTask:
			child.queue_free()
