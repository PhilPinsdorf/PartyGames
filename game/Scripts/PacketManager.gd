extends Node

signal participate_request
signal received_username
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
	
	print(obj["code"])
	match int(obj["code"]):
		100:
			# Request to participate
			emit_signal("participate_request")
		101:
			# Client sends Username
			emit_signal("received_username")
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
	pass
