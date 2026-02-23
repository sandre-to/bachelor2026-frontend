extends Node

# Notater:
# - Raffiner transportentitetene
# - Gjør Device til en klasse andre klasser arver fra.
#	På den måten kan man inkludere serverprosessen i klassen,
#	og gir den tilgang til deviceobjektet.

func _ready() -> void:
	var user: UserDevice = UserDevice.new("user", "9.9.9.9")
	var ftp_server: Server = Server.new("fuckass-server", "1.2.3.4")
	var ftp_process: AbstractServerProcess = BasicFTPProcess.new()
	
	var network: SPNetwork = SPNetwork.new()
	network.let_device_connect(ftp_server)
	network.let_device_connect(user)
	
	var file1: File = File.new("sus-file.txt", null)
	var file2: File = File.new("not-sus-file.txt", null)
	var file3: File = File.new("kinda-sus-file.txt", null)

	ftp_process.resources[file1.name] = file1
	ftp_process.resources[file2.name] = file2
	ftp_process.resources[file3.name] = file3

	ftp_server.open_port(21, ftp_process)
	
	var http_request: HttpReq = HttpReq.new("GET", {"files": ["sus-file.txt"]})
	var dp: DataPacket = DataPacket.new("9.9.9.9", "1.2.3.4", 21, http_request)
	user.send_datapacket(dp)
	
	print("RESPONS: ")
	print(dp)
	
