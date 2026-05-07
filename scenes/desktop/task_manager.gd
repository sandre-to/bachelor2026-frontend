class_name TaskManager extends Control

const TASK: PackedScene = preload("res://tasks/base_task.tscn")

@export var current_bulk: String = "bulk_1"

@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton
@onready var dialogue_panel: DialoguePanel = %DialoguePanel
@onready var bun_boss: Panel = %BunBoss
@onready var boss_flag: LineEdit = %BossFlag

# --- Oppgave knapper ---
@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3
@onready var task_4: Button = %Task4

var current_task: BaseTask = null
var buttons: Dictionary[int, Button] = {}
var index: int = 1
var completed_bulk: bool = false

func _ready() -> void:
	missions_panel.hide()
	SignalBus.task_completed.connect(_on_task_completed)
	
	buttons = {
		1: task_1,
		2: task_2,
		3: task_3,
		4: task_4
	}
	
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
	tween.tween_property(panel, "modulate:a", 0.0, 0.025)
	tween.tween_callback(func(): panel.hide())

func _on_task_1_pressed() -> void:
	spawn_task(0)

func _on_task_2_pressed() -> void:
	spawn_task(1)

func _on_task_3_pressed() -> void:
	spawn_task(2)

func _on_task_4_pressed() -> void:
	spawn_task(3)

func spawn_task(index: int) -> void:
	if current_task:
		current_task.queue_free()
		current_task = null
	
	fade_out(missions_panel)
	
	var task := TASK.instantiate() as BaseTask
	add_child(task)
	
	task.set_data_info(current_bulk, index)
	current_task = task
	
	task.global_position += Vector2(-100, 0)
	fade_in(task)

func close_tasks() -> void:
	for child in get_children():
		if child is BaseTask:
			child.queue_free()

func _on_task_completed(_type: String) -> void:
	if completed_bulk: return
	
	if current_task:
		current_task.queue_free()
		current_task = null
	
	fade_in(missions_panel)
	
	# Starter alltid på første oppgave
	# Når riktig flagg er skrevet inn
	# Lås oppgaveknappen, og åpne neste [Task 1 låst -> Task 2 åpen]
	buttons[index].disabled = true
	buttons[index].text = "COMPLETED"
	buttons[index].modulate = Color.LIME_GREEN
	index += 1
	
	if index > buttons.size():
		# Starter boss nivå når alle oppgavene er ferdig
		completed_bulk = true
		fade_out(missions_panel)
		task_button.hide()
		await get_tree().create_timer(0.15).timeout
		
		dialogue_panel.show()
		dialogue_panel.start_dialogue("boss_start")
		return
	
	buttons[index].disabled = false

func reset_bulk(bulk: String) -> void:
	current_task = null
	index = 1
	completed_bulk = false
	current_bulk = bulk
