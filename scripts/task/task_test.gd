extends Node

func _ready() -> void:
	var json_dict: Dictionary = {
		"objects": {
			"NPC-messenger": {
				"type": "npc-messenger",
				"name": "boss",
				"app": "skype"
			},
			"dir": {
				"type": "directory",
				"name": "sus-files",
				"content": [
					"target-file",
					"dummy-file"
				]
			},
			"target-file": {
				"type": "file",
				"name": "sus-file.txt",
				"metadata": "size: 50000YB",
				"content": "hihi her er det noe spennende!!"
			},
			"dummy-file": {
				"type": "file",
				"name": "kinda-sus-file.txt",
				"metadata": "size: 50000YB",
				"content": "hihi her er det kanskje noe spennende!!"
			}
		},
		"key-events": {
			"task-start": {
				"cmd": [
					{
						"type": "send-message",
						"sender": "NPC-messenger",
						"text": "denne filen er hella sus, finn ut a'",
						"attachments": [
        	                "target-file"
						]
					}
				]
			},
			"correct-flag-submit": {
				"cmd": [
					{
						"type": "send-message",
						"sender": "NPC-messenger",
						"text": "bra jobba bro!!!"
					}
				]
			},
			"wrong-flag-submit": {
				"cmd": [
					{
						"type": "send-message",
						"sender": "NPC-messenger",
						"text": "wtf"
					}
				]
			}
		}
	} 
	
	var task_parser: TaskParser = TaskParser.new()
	
	var start_time = Time.get_ticks_usec()
	var task: Task = task_parser.parse(JSON.stringify(json_dict))
	var end_time = Time.get_ticks_usec()
	print("Tid brukt: ", end_time - start_time, "us")
	
	if task_parser.error_code != 0:
		print(task_parser.get_error())
		return
	
	print("dir: ", task.objects["dir"])
