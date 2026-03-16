@abstract
class_name Tool extends Control

enum ToolType {
	CRYPTO_TOOL,
	STEGANO_TOOL,
	WEB_TOOL
}

@export var tool_type: ToolType
