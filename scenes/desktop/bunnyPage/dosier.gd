extends Control

@onready var exit_button: Button = $MarginContainer/Dossier/EnvelopePanel/ExitButton
@onready var dossier_page: Panel = $MarginContainer/Dossier/EnvelopePanel/HBoxContainer/PagePanel
@onready var dossier: Panel = $MarginContainer/Dossier/EnvelopePanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_button_pressed() -> void:
	hide()
