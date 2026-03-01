extends Node

func _ready() -> void:
	var json_dict: Dictionary = {
		"objects": {
			"NPC-messenger": {
				"type": "npc-messenger",
				"name": "boss",
				"app": "skype"
			},
			"server": {
				"type": "server",
				"hostname": "hemmelig-server"	
			},
			"ftp-process": {
				"type": "server-process",
				"process-type": "basic-ftp-process",
				"resources": [
					"dir",
	                "dummy-file"
				]
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
	
	var errno: int = task_parser.get_error()
	if errno != 0:
		print(errno)
		print(task_parser.get_error_desc())
		return


	# Test serverprosess
	var net: SPNetwork = SPNetwork.new()	
	
	var server: Server = task.objects["server"]
	server.open_port(21, task.objects["ftp-process"])
	
	var user: UserDevice = UserDevice.new("user")

	net.connect_device(server)
	net.connect_device(user)
	var datapacket_sent: DataPacket = DataPacket.new(
		user.get_ip(), server.get_ip(), 21,
		HttpReq.new("GET", {
			"files": ["sus-files"]
		})
	)
	
	var response: DataPacket = user.send_datapacket(datapacket_sent)
	print(response)
