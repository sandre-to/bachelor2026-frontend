class_name ToolSelector extends Control

# --- Tool interface ---
@onready var tool_panel: Panel = %ToolPanel
@onready var caesar_cipher: CaesarCipher = %CaesarCipher
@onready var web_exploit: WebExploit = %WebExploit
@onready var steg_tool: StegTool = %StegTool
@onready var notepad: NotepadApp = %NotepadApp

func _on_crypto_pressed() -> void:
	var was_visible = caesar_cipher.visible
	hide_selected_tools()
	caesar_cipher.visible = not was_visible

func _on_stegano_pressed() -> void:
	var was_visible = steg_tool.visible
	hide_selected_tools()
	steg_tool.visible = not was_visible

func _on_web_pressed() -> void:
	var was_visible = web_exploit.visible
	hide_selected_tools()
	web_exploit.visible = not was_visible

func hide_selected_tools() -> void:
	for panel in tool_panel.get_children():
		if panel.visible:
			panel.hide()
			
func _on_notepad_pressed() -> void:
	var was_visible = notepad.visible
	hide_selected_tools()
	notepad.visible = not was_visible
	
	if notepad.visible:
		notepad.open_personal_notes()
