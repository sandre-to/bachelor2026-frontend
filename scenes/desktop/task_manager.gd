class_name TaskManager extends Control

const CRYPTO_TASK: PackedScene = preload(
	"res://tasks/crypto/crypto_task.tscn")

const STEGANO_TASK: PackedScene = preload(
	"res://tasks/steg/steg_task.tscn")
	
const WEB_TASK: PackedScene = preload(
	"res://tasks/web_exploit/web_task.tscn")
	
@onready var missions_panel: Panel = $Panel
@onready var task_button: Button = $TaskButton

# --- Oppgave knapper ---
@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3
@onready var task_4: Button = %Task4

var current_task: BaseTask = null
var buttons: Dictionary[int, Button] = {}
var index: int = 1

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
	tween.tween_property(panel, "modulate:a", 0.0, 0.25)
	tween.tween_callback(func(): panel.hide())

func _on_task_1_pressed() -> void:
	spawn_task(CRYPTO_TASK, "level_1.1")

func _on_task_2_pressed() -> void:
	spawn_task(STEGANO_TASK, "")

func _on_task_3_pressed() -> void:
	spawn_task(WEB_TASK, "")

func _on_task_4_pressed() -> void:
	spawn_task(CRYPTO_TASK, "level_1.4")

func spawn_task(task_scene: PackedScene, key: String) -> void:
	if task_scene == null || current_task != null: return
	fade_out(missions_panel)
	
	var task := task_scene.instantiate()
	add_child(task)
	
	if task is CryptoScene:
		task.set_data_info(key)
	
	current_task = task
	
	task.global_position += Vector2(-100, 0)
	fade_in(task)
	task.start()

func close_tasks() -> void:
	for child in get_children():
		if child is BaseTask:
			child.queue_free()

func _on_task_completed() -> void:
	if current_task:
		current_task.queue_free()
		current_task = null
	
	fade_in(missions_panel)
	
	# Starter alltid på første oppgave
	# Når riktig flagg er skrevet inn
	# Lås oppgaveknappen, og åpne neste [Task 1 låst -> Task 2 åpen]
	buttons[index].disabled = true
	buttons[index].text = "COMPLETED"
	index += 1
	if index > buttons.size():
		return
	buttons[index].disabled = false
