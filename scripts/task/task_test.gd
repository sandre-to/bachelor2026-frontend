extends Node

func _ready() -> void:

	var json_dict: Dictionary = {
		"objects": {
			"NPC-messenger": {
				"type": "npc-messenger",
				"name": "boss",
				"app": "skype"
			},
			"ftp-server": {
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
						"type": "open-port",
						"server": "ftp-server",
						"port": 21,
						"process": "ftp-process"
					},
				]
			},
			"correct-flag-submit": {
				"cmd": [

				]
			},
			"wrong-flag-submit": {
				"cmd": [

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

	# Gi oppgaven en referanse til nettverket
	task.network = SPNetwork.new()
	
	# Lag brukerens nettverkskort
	var user: UserDevice = UserDevice.new("bigsoda")
	task.network.connect_device(user)

	# Start oppgaven
	task.start()

	var httpreq: HttpReq = HttpReq.new("GET", {"files": ["sus-files"]})
	var dp: DataPacket = DataPacket.new(
		user.get_ip(), task.objects.get("ftp-server").get_ip(), 21,
		httpreq
	)
	print(dp)
	print("----------------------------------------")
	var response := user.send_datapacket(dp)
	print(response)
