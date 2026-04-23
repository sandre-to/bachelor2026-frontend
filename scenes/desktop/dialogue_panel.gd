class_name DialoguePanel extends Panel

@export var entry_dialogue: String = "boss_start"
@export var dialog_move_speed: float = 0.35
@onready var next_button: Button = $NextButton
@onready var bunny_image: TextureRect = $"../BunBoss/BunnyImage"
@onready var boss_flag: LineEdit = %BossFlag

@onready var text: RichTextLabel = %Text

var dialogue_data := {}
var dialogue := []
var current_index := 0
var current_dialogue_key := ""

var active_tween: Tween
var is_typing := false

func _ready() -> void:
	load_dialogue()
	start_dialogue(entry_dialogue)
	
func start_dialogue(key: String) -> void:
	if key in dialogue_data:
		current_dialogue_key = key
		dialogue = dialogue_data[key]
		current_index = 0
		show_next_line()
	else:
		push_error("Dialogue key not found: " + key)

func load_dialogue() -> void:
	var file := FileAccess.open(
		"res://tasks/boss/boss_1.json", 
		FileAccess.READ)
		
	dialogue_data = JSON.parse_string(file.get_as_text())

func show_next_line():
	if current_index < dialogue.size():
		text.text = dialogue[current_index]
		current_index += 1
		type_text()
	else:
		end_of_dialogue()

func _on_next_button_pressed() -> void:
	if current_index >= dialogue.size():
		end_of_dialogue()
	else:
		show_next_line()

func type_text() -> void:
	text.visible_characters = 0
	
	for i in text.text.length():
		text.visible_characters = i + 1
		await get_tree().create_timer(0.028, false).timeout

func end_of_dialogue() -> void:
	match current_dialogue_key:
		"boss_start":
			var web_data := load(
				"res://tasks/web_exploit/web1.boss.tres")
			SignalBus.send_boss_web.emit(web_data)
			next_button.disabled = true
			active_tween = create_tween()
			active_tween.set_ease(Tween.EASE_IN)
			active_tween.tween_property(
				self,
				"position",
				position + Vector2(650, 180),
				0.24
			)

func _on_boss_flag_text_submitted(new_text: String) -> void:
	if new_text == "carrot":
		boss_flag.editable = false
		text.text = "You did it!"
