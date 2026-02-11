extends Node

@export var tools: Array[PackedScene]

func find_tool_scene(tool: Tool.ToolType) -> PackedScene:
	for scene in tools:
		var instance: Tool = scene.instantiate()
		if instance.tool_type == tool:
			return scene
	return null
