extends BaseTask
class_name ExpTask

var exposed_localhost_server: Server
var sus_file: TextFile

func _on_start() -> bool:
	
	# Lag fil (med flagg)
	sus_file = TextFile.new("borislockpicks.txt")
	sus_file.metadata["flagg"] = "dette er flagget ass: " + task.backend_data["flagg"]
	
	# Lag server
	exposed_localhost_server = Server.new("localhost")
	exposed_localhost_server.open_port(
		task.backend_data["serverIP"],
		server_process
	)
	Network.connect_server(
		exposed_localhost_server,
		task.backend_data["serverPort"]
	)
	
	FileSystem.insert_into(FileSystem.DOCUMENT_DIR, sus_file)
	
	return true



func server_process(dp: DataPacket) -> DataPacket:
	var body: Dictionary = dp.get_content()
	var reply_body: Dictionary = {
		"code": 404,
		"content": "Not Found"
	}
	
	if body.get("file") == "borislockpicks.txt":
		reply_body = {
			"code": 200,
			"content": sus_file
		}
		
	return DataPacket.create_reply_packet(
		dp, reply_body
	)
