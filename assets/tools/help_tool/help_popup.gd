extends Control

@onready var title_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var usage_label = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HowToUse
@onready var example_label = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/Example
@onready var theory_label = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/Theory
@onready var close_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CloseButton

func _ready():
	if close_button != null:
		close_button.pressed.connect(close)
	##	SOFIE:bytter til hide etter testing
	## show()
	hide()

func open(data: Dictionary):
	title_label.text = data.get("title", "")
	usage_label.text = data.get("usage", "")
	example_label.text = data.get("example", "")
	theory_label.text = data.get("theory", "")
	show()

func close():
	hide()

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		close()
