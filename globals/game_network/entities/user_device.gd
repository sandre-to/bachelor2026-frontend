extends AbstractDevice
class_name UserDevice

# UserDevice:
# Denne klassen representerer nettverkskortet til spilleren.

func _init(hostname: String) -> void:
	super(hostname)






# Receive_datapacket(): Metoden som kjører når nettverket ruter en pakke
#				  TODO:	Her må gutta bajas legge til egen logikk som kobler 
#						nettverket opp mot de forskjellige appene.
#				   Ide:	Kanskje UserDevice også kan ha en port-dict som knytter
#						en gitt port opp mot en app?
func receive_datapacket(datapacket: DataPacket) -> DataPacket:
	return null
	
