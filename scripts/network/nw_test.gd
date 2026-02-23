extends Node

# Notater:
# - Raffiner transportentitetene
# - Gjør Device til en klasse andre klasser arver fra.
#	På den måten kan man inkludere serverprosessen i klassen,
#	og gir den tilgang til deviceobjektet.

func _ready() -> void:
	
	# Lag bruker nettverkskortet, serveren og serverprosessen
	var user: UserDevice = UserDevice.new("user")
	var ftp_server: Server = Server.new("fuckass-server")
	var ftp_process: AbstractServerProcess = BasicFTPProcess.new()

	# Lag nettverket og la brukeren og serveren koble til
	var network: SPNetwork = SPNetwork.new()
	network.let_device_connect(ftp_server)
	network.let_device_connect(user)
	
	# Lag noen filer serveren kan gi
	var file1: File = File.new("sus-file.txt", null)
	file1.update_content("LOOOOOOL her er det noe sus >:(")
	var file2: File = File.new("not-sus-file.txt", null)
	var file3: File = File.new("kinda-sus-file.txt", null)

	# Gi serveren filene
	ftp_process.resources[file1.name] = file1
	ftp_process.resources[file2.name] = file2
	ftp_process.resources[file3.name] = file3

	# Åpne port 21 hos serveren og assosier prosessen med den
	ftp_server.open_port(21, ftp_process)
	
	# Lag en datapakke som inneholder en HTTP-forespørsel
	var http_request: HttpReq = HttpReq.new("GET", {"files": ["sus-file.txt"]})
	var dp: DataPacket = DataPacket.new(user.get_ip(), ftp_server.get_ip(), 21, http_request)
	var response: DataPacket = user.send_datapacket(dp)
	
	print("----------------| Forespørsel |------------------")
	print(dp)
	print("-------------------------------------------------")
	print()
	print("------------------| Respons |--------------------")
	print(response)
	print("-------------------------------------------------")
	
	# Litt yalla måte å ekstrakte filen fra responsen men jaja
	print(response.get_data().get_content()["files"][0].get_content())
