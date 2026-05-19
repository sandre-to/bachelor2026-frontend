#håndterer valg og visning av tutorial-verktøy
class_name TutorialToolSelector extends Control

# --- Tool interface ---
@onready var tool_panel: Panel = %ToolPanel
@onready var caesar_cipher: CaesarCipher = %CaesarCipher
@onready var steg_tool: StegTool = %StegTool
@onready var web_exploit: WebExploit = %WebExploit


func _on_crypto_pressed() -> void:
	var was_visible = caesar_cipher.visible
	hide_selected_tools()
	caesar_cipher.visible = not was_visible

#skjuler aktive verktøy før nytt åpnes
func hide_selected_tools() -> void:
	for panel in tool_panel.get_children():
		if panel.visible:
			panel.hide()


func _on_steg_tool_button_pressed() -> void:
	var was_visible = steg_tool.visible
	hide_selected_tools()
	steg_tool.visible = not was_visible



func _on_web_tool_button_pressed() -> void:
	var was_visible = web_exploit.visible
	hide_selected_tools()
	web_exploit.visible = not was_visible
