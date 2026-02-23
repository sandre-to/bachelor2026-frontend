extends AbstractServerProcess
class_name BasicFTPProcess

# BasicFTPProcess:
# Denne serverprosessen gir klienten en fil basert på navnet.
# Datapakken forventer en HTTP-forespørsel med feltene:
# files: *tabell med filnavn*

func action(datapacket: DataPacket) -> DataPacket:
	var response: HttpResponse
	if not datapacket.get_data() is HttpReq:
		response = HttpResponse.new(400, {})	# Bad request
		return DataPacket.copy_header(
			datapacket,
			response
		)
	
	if datapacket.get_data().get_method() != "GET":
		response = HttpResponse.new(405, {})	# Method not allowed
		return DataPacket.copy_header(
			datapacket,
			response
		)

	var http_body: Dictionary = datapacket.get_data().get_content()
	if not http_body.has("files"):
		response = HttpResponse.new(400, {"missing-field": "files"})	# Bad request
		return DataPacket.copy_header(
			datapacket,
			response
		)

	var file_names: Array[String] = http_body.get("files")
	var files_to_give: Array[FileEntity] = []
	for file_name in file_names:
		var resource: FileEntity = _get_resource(file_name)
		if resource == null:
			response = HttpResponse.new(404, {"missing-files": file_name})	# Not fouund
			return DataPacket.copy_header(
				datapacket,
				response
			)
		files_to_give.append(resource)

	response = HttpResponse.new(200, {"files": files_to_give})
	return DataPacket.copy_header(
		datapacket,
		response
	)


# _get_resource():	Gir en filressurs
func _get_resource(file_entity_name: String) -> FileEntity:
	for name in resources:
		if name == file_entity_name:
			return resources[name]
	return null
