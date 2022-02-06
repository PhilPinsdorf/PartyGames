extends Node

func _ready():
	pass
	
func send_packet(code):
	var dict = {}
	dict["code"] = code
	Network.send_packet(JSON.print(dict))
	
func send_packet_value(code, value):
	var dict = {}
	dict["code"] = code
	dict["value"] = value
	Network.send_packet(JSON.print(dict))
