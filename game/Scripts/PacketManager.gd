extends Node

signal user_connected
signal reflex_button_down
signal reflex_button_up
signal driving_button

func _ready():
	Network.connect("received_packet", self, "_process_incoming_packet")
	pass
	
func _process_incoming_packet(id, content):
	var json = JSON.parse(content)
	var obj = json.result
	
	# 100 - 109 => Initial Connection
	# 110 - 119 => Reflexe Button
	# 120 - 129 => Wheel Buttons

	match int(obj["code"]):
		100:
			# Request to participate
			# Checking participate requirements
			if PlayerManager.user_count() < PlayerManager.MAX_PLAYERS:
				send_packet_value(id, 200, true)
				
		101:
			# Client sends Username
			var username = obj["value"]
			var count = PlayerManager.user_count()
			PlayerManager.add_user(id, username)
			PlayerManager.add_user_random_color(id, count)
			emit_signal("user_connected", username, count)
			var color = Global.avalibleColors[count]
			send_packet_value(id, 201, {"r": color.r, "g": color.g, "b": color.b})
			
		110:
			# Reflex Button Down
			emit_signal("reflex_button_down")
		111:
			# Reflex Button Up
			emit_signal("reflex_button_up")
		120:
			# Driving Button Left Down
			emit_signal("driving_button", id, 0)
		121:
			# Driving Button Left Up
			emit_signal("driving_button", id, 1)
		122:
			# Driving Button Right Down
			emit_signal("driving_button", id, 2)
		123:
			# Driving Button Right Up
			emit_signal("driving_button", id, 3)

func send_packet(id, code):
	var dict = {}
	dict["code"] = code
	Network.send_packet(id, JSON.print(dict))

func send_packet_value(id, code, value):
	var dict = {}
	dict["code"] = code
	dict["value"] = value
	Network.send_packet(id, JSON.print(dict))
