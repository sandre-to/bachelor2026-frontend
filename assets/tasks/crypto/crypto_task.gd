class_name CryptoTask extends Control

var flag_solution: String = "hellothere"

@onready var enter_flag: LineEdit = %EnterFlag
@onready var hint_1_panel: Panel = $Hint1Panel
@onready var title: Label = %Title
@onready var puzzle: RichTextLabel = %Puzzle

# --- Knapper ---
@onready var hint_1: Button = %Hint1
@onready var hint_2: Button = %Hint2
@onready var hint_3: Button = %Hint3

@onready var hint_container: HBoxContainer = %HintContainer
@onready var confirm_button: Button = %ConfirmButton

func _ready() -> void:
	hint_1_panel.hide()

func _on_confirm_button_pressed() -> void:
	if enter_flag.text.to_lower() == flag_solution:
		completed_task()
	else:
		print("wrong answer")

func _on_hint_1_pressed() -> void:
	hint_1_panel.visible = not hint_1_panel.visible

func completed_task() -> void:
		title.text = "Task completed!"
		puzzle.text = ""
		
		for button in hint_container.get_children():
			button.disabled = true
		
		confirm_button.disabled = true
		enter_flag.editable = false
		enter_flag.drag_and_drop_selection_enabled = false
		enter_flag.selecting_enabled = false
