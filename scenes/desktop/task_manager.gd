class_name TaskManager extends Control

const TASK_1: PackedScene = preload(
	"res://assets/tasks/crypto/crypto_task.tscn")

@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

# --- Oppgave knapper ---
@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3

var current_task: BaseTask = null
var task_buttons: Dictionary

func _ready() -> void:
	task_buttons = {
		"task_1": task_1,
		"task_2": task_2,
		"task_3": task_3
	}
	
	missions_panel.hide()
	SignalBus.task_completed.connect(_on_task_completed)
		
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

func _on_task_2_pressed() -> void:
	pass

func _on_task_3_pressed() -> void:
	pass

func spawn_task(task_scene: PackedScene) -> void:
	fade_out(missions_panel)
	
	var task := task_scene.instantiate()
	current_task = task
	add_child(task)
	task.global_position += Vector2(-80, 0)
	fade_in(task)

func _on_task_completed(id: String) -> void:
	if current_task and current_task.task.completed:
		var button: Button = task_buttons[id]
		if not button: 
			push_error("Button does not exist. Check name spelling. ")
			return
			
		button.disabled = true
		button.text = id.to_upper() + ": COMPLETED!"
