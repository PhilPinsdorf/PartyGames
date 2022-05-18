extends Node

signal update_lobby
signal button_pressed

enum Packet {PARTICIPATE_RESPONSE = 200, COLOR_RESPONSE = 201, CHANGE_TO_REFLEX = 210, CHANGE_TO_DRIVING = 220}

func _ready():
	Network.connect("received_packet", self, "_process_incoming_packet")
	pass
	
func _process_incoming_packet(id, content):
	var json = JSON.parse(content)
	var obj = json.result

	match int(obj["code"]):
		100:
			# Request to participate
			# Checking participate requirements
			send_packet_value(id, Packet.PARTICIPATE_RESPONSE, (PlayerManager.user_count() < PlayerManager.MAX_PLAYERS))
			
		101:
			# Client sends Username
			var username = obj["value"]
			var spot = PlayerManager.add_user(id, username)
			emit_signal("update_lobby")
			var color = Global.avalibleColors[spot]
			send_packet_value(id, Packet.COLOR_RESPONSE, {"r": color.r, "g": color.g, "b": color.b})
			
		110:
			# Reflex Button Down
			emit_signal("button_pressed", id, 0)
		111:
			# Reflex Button Up
			emit_signal("button_pressed", id, 1)
		120:
			# Driving Button Left Down
			emit_signal("button_pressed", id, 0)
		121:
			# Driving Button Left Up
			emit_signal("button_pressed", id, 1)
		122:
			# Driving Button Right Down
			emit_signal("button_pressed", id, 2)
		123:
			# Driving Button Right Up
			emit_signal("button_pressed", id, 3)

func send_packet(id, code):
	var dict = {}
	dict["code"] = code
	Network.send_packet(id, JSON.print(dict))

func send_packet_value(id, code, value):
	var dict = {}
	dict["code"] = code
	dict["value"] = value
	Network.send_packet(id, JSON.print(dict))
