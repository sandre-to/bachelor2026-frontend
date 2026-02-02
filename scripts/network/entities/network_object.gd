@abstract
extends Resource
class_name NetworkObject 

# Kontaktinformasjon
# IP-adresser er alltid f.eks: "123.241.2.41"
var ip_addr: String

# En port skal aldri være mindre enn 0 og mer enn 65535
var open_ports: Array[int]

# Bare et menneskeligleselig navn for en maskin; kan være null
var hostname: String

# Brannmuren
var firewall: Firewall

# Alle prosessene datapakken skulle få
@abstract
func process(_packet: NetworkPacket) -> HttpResponse
