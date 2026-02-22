extends AbstractServerProcess
class_name BasicFTPProcess

# BasicFTPProcess:
# Denne serverprosessen gir klienten en fil basert på navnet.
# Datapakken forventer en HTTP-forespørsel med feltene:
# files: *tabell med filnavn*

func action(datapacket: DataPacket) -> DataPacket:
	var response: HttpResponse
	if not datapacket.get_data() is HttpReq:
		response = HttpResponse.new(HttpResponse.ResponseCode.BAD_REQUEST, {})
		return DataPacket.copy_header(
			datapacket,
			datapacket.get_receiver_port(),
			response
		)
	
	
	
	return null
