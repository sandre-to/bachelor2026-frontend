class_name WordManager extends GridContainer

func get_letter_boxes() -> Array:
	return get_children()

func find_focused() -> LetterBox:
	for child: LetterBox in get_children():
		if child.focused:
			return child
	return null
