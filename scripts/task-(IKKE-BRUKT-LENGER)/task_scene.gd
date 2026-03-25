extends Node

const TEST_TASK: Dictionary = {
	"objects": {
		"main-server": {
			"type": "server",
			"hostname": "sus_scary_server"
		},
		"main-server-process": {
			"type": "server-process",
			"process-type": "basic-ftp-process",
			"resources": [
                "sus-file"
			]
		},
		"sus-file": {
			"type": "file",
			"name": "some_file.txt",
			"metadata": "Size: 0b",
			"content": "L + RATIO UNC"
		}
	},
	"key-events": {
		"task-start": {
			"cmd": [
				{
					"type": "open-port",
					"server": "main-server",
					"port": 21,
					"process": "main-server-process"
				}
			]
		},
		"correct-flag-submit": {
			"cmd": [
				{
					"type": "close-port",
					"server": "main-server",
					"port": 21
				}
			]
		},
		"wrong-flag-submit": {
			"cmd": [
			]
		}
	},
	"triggers": [
	],
	"details": {
		"hint-costs": [
			0.25, 0.25, 0.5
		]
	}
}

# Innholdet til oppgaven
var active_task: Task

# Objektet som gjør om JSON -> Task
var task_parser: TaskParser = TaskParser.new()


func _ready() -> void:
	retrieve_task(0)
	var ip = active_task.objects["main-server"].get_ip()
	var response = GameNetwork.user_device.send_datapacket(
		ip, 21, HttpReq.new(
			"GET", {}
		)
	)
	
	print(response)
	
	
# Retrieve_task():	Henter en oppgave og parser den (midlertidig avkoblet fra backenden)
func retrieve_task(id: int) -> void:
	# 1 Henter fra backend
	# 2 Sjekk svar (om fikk oppgave)
	# 3 Parser innholdet
	# 4 Send parse-status melding
	# 5 Start
	
	# Midlertidig test på en statisk oppgave
	var json_task: String = JSON.stringify(TEST_TASK)
	active_task = task_parser.parse(json_task)
	if task_parser.get_error() != 0:
		print(task_parser.get_error_desc())
		push_error("kunne ikke parse oppgaven ass")
	print(active_task)
