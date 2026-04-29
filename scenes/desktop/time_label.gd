class_name TimeLabel extends Label


func _process(_delta: float) -> void:
	var time := Time.get_time_dict_from_system()
	var time_text = "%02d:%02d" % [time.hour, time.minute]
	text = time_text
