extends Node

@export var scenes: Array[PackedScene]

# --- Hovedmetodene for å finne verktøy eller oppgave er ganske like
# --- Forskjellen er hva man sender inn som argument
# --- Husk å bruke "find_tool" for verktøy, og "find_task" for oppgave

func find_tool(type: Tool.ToolType) -> PackedScene:
	for scene in scenes:
		var instance := scene.instantiate() as Tool
		# Vil fortsette dersom scenen ikke er av type "Tool"
		if instance == null: continue
		
		if instance is Tool and instance.tool_type == type:
			instance.queue_free()
			return scene
		instance.queue_free()
	return null

func find_task(type: BaseTask.TaskType) -> PackedScene:
	for scene in scenes:
		var instance := scene.instantiate() as BaseTask
		# Vil fortsette dersom scenen ikke er av type "BaseTask"
		if instance == null: continue
		
		if instance is BaseTask and instance.task_type == type:
			instance.queue_free()
			return scene
		instance.queue_free()
	return null
