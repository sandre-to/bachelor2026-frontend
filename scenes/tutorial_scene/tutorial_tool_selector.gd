class_name TutorialToolSelector extends Control

# --- Tool interface ---
@onready var tool_panel: Panel = %ToolPanel
@onready var caesar_cipher: CaesarCipher = %CaesarCipher

func _on_crypto_pressed() -> void:
	var was_visible = caesar_cipher.visible
	hide_selected_tools()
	caesar_cipher.visible = not was_visible

func hide_selected_tools() -> void:
	for panel in tool_panel.get_children():
		if panel.visible:
			panel.hide()
