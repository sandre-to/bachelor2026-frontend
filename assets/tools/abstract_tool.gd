@abstract
class_name Tool extends Control

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
	print(get_help_data())
	
	if help_popup_instance != null:
		help_popup_instance.open(get_help_data())

func get_help_data() -> Dictionary:
	match tool_type:
		ToolType.CRYPTO_TOOL:
			return {
				"title": "Crypto Tool",
				"usage": "Enter text and try different decoding methods.",
				"example": "HELLO → KHOOR with a shift of 3.",
				"theory": "Cryptography is about hiding and decoding information."
			}
		ToolType.STEGANO_TOOL:
			return {
				"title": "Steganography Tool",
				"usage": "Inspect image files for hidden information in metadata or other embedded content.",
				"example": "An image file may contain a hidden comment or other metadata with useful clues.",
				"theory": "Steganography is the practice of hiding information inside other files, often images."
			}
		ToolType.WEB_TOOL:
			return {
				"title": "Web Tool",
				"usage": "Inspect pages, requests, and responses to find hidden clues or vulnerable endpoints.",
				"example": "A hidden route such as /admin may still be accessible even if it is not linked.",
				"theory": "Web security focuses on how applications handle input, access control, and data exposure."
			}

	return {
		"title": "Help",
		"usage": "No help is available for this tool yet.",
		"example": "",
		"theory": ""
	}
