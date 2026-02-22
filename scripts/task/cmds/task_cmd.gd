@abstract
extends Resource
class_name TaskCMD

# TaskCMD:
# Dette er en abstakt klasse som beskriver en kommando 
# en oppgave kan utføre.


@abstract
func action() -> bool
