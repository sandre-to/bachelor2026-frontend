@abstract
class_name Tool
extends Control

enum ToolType {
	CRYPTO_TOOL,
	STEGANO_TOOL,
	WEB_TOOL
}

@export var tool_type: ToolType

var HelpPopupScene = preload("res://assets/tools/help_tool/help_tool.tscn")
var help_popup_instance
var help_button: HelpButton

func _ready() -> void:
	help_popup_instance = HelpPopupScene.instantiate()
	get_tree().root.call_deferred("add_child", help_popup_instance)

	help_button = find_child("HelpButton", true, false) as HelpButton
	print("help_button: ", help_button)

	if help_button != null:
		help_button.help_requested.connect(_on_help_pressed)

func _on_help_pressed() -> void:
	print("HELP CLICKED")
	if help_popup_instance != null:
		help_popup_instance.open(get_help_data())

func get_help_data() -> Dictionary:
	match tool_type:
		ToolType.CRYPTO_TOOL:
			return {
				"title": "Crypto Tool",
				"usage": "Skriv inn tekst og prøv dekryptering.",
				"example": "HELLO → KHOOR (shift 3)",
				"theory": "Kryptografi handler om å skjule og dekode informasjon."
			}
		ToolType.STEGANO_TOOL:
			return {
				"title": "Steganografi Tool",
				"usage": "Analyser bilder for skjult informasjon.",
				"example": "image.png → hidden comment: flag{...}",
				"theory": "Steganografi skjuler data i andre filer, ofte bilder."
			}
		ToolType.WEB_TOOL:
			return {
				"title": "Web Tool",
				"usage": "Undersøk nettsider og requests.",
				"example": "/admin → skjult endpoint",
				"theory": "Web-sikkerhet handler om hvordan applikasjoner håndterer data."
			}

	return {
		"title": "Help",
		"usage": "No help available.",
		"example": "",
		"theory": ""
	}
