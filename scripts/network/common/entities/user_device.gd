extends AbstractDevice
class_name UserDevice

# UserDevice:
# Denne klassen representerer nettverkskortet til spilleren.

func _init(hostname: String, ip: String = "") -> void:
	super(hostname, ip)


# Send_datapacket(): Sender en datapakke og returnerer responsen
func send_datapacket(datapacket: DataPacket) -> DataPacket:
	return get_network().route_packet(datapacket)


# Receive_datapacket(): Metoden som kjører når nettverket ruter en pakke
#				  TODO:	Her må gutta bajas legge til egen logikk som kobler 
#						nettverket opp mot de forskjellige appene.
#				   Ide:	Kanskje UserDevice også kan ha en port-dict som knytter
#						en gitt port opp mot en app?
func receive_datapacket(datapacket: DataPacket) -> DataPacket:
	return null
	
