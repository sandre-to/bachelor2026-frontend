extends Control
class_name NotepadApp

@onready var panel: PanelContainer = $PanelContainer
@onready var text_edit: TextEdit = $PanelContainer/MarginContainer/VBoxContainer/TextEdit
@onready var status_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatusLabel
@onready var save_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Save
@onready var load_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Load
@onready var clear_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Clear
@onready var txt_name_input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/TxtNameInput

var current_file_path: String = ""
var is_read_only_file: bool = false
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	open_personal_notes()

func open_personal_notes() -> void:
	current_file_path = ""
	is_read_only_file = false
	text_edit.editable = true
	save_button.disabled = false
	load_button.disabled = false
	clear_button.disabled = false
	load_note()

func open_reference_file(file_name: String, content: String) -> void:
	current_file_path = ""
	is_read_only_file = true
	text_edit.text = content
	text_edit.editable = false
	save_button.disabled = true
	load_button.disabled = true
	clear_button.disabled = true
	status_label.text = "Viewing: %s" % file_name

func new_personal_note() -> void:
	current_file_path = ""
	is_read_only_file = false
	text_edit.text = ""
	text_edit.editable = true
	save_button.disabled = false
	load_button.disabled = false
	clear_button.disabled = false
	status_label.text = "New note"

func get_save_path() -> String:
	var file_name := txt_name_input.text.strip_edges()

	if file_name.is_empty():
		file_name = "untitled"

	return "user://%s.txt" % file_name


func save_note() -> void:
	if is_read_only_file:
		status_label.text = "Read-only file"
		return

	var path := get_save_path()
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		status_label.text = "Failed to save"
		return

	file.store_string(text_edit.text)
	status_label.text = "Saved: %s" % path.get_file()

func load_note() -> void:
	var path := get_save_path()

	if not FileAccess.file_exists(path):
		text_edit.text = ""
		status_label.text = "No saved note"
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		status_label.text = "Failed to load"
		return

	text_edit.text = file.get_as_text()
	status_label.text = "Loaded: %s" % path.get_file()

func clear_note() -> void:
	if is_read_only_file:
		status_label.text = "Read-only file"
		return

	text_edit.text = ""
	status_label.text = "Cleared"

func _on_save_pressed() -> void:
	save_note()

func _on_load_pressed() -> void:
	if is_read_only_file:
		status_label.text = "Read-only file"
		return
	load_note()

func _on_clear_pressed() -> void:
	clear_note()


func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		var new_pos := get_global_mouse_position() - drag_offset
		var screen_size := get_viewport_rect().size

		new_pos.x = clamp(new_pos.x, 0.0, screen_size.x - panel.size.x)
		new_pos.y = clamp(new_pos.y, 0.0, screen_size.y - panel.size.y)

		global_position = new_pos
