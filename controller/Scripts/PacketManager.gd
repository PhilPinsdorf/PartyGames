extends Node

signal update_color

var username

func _ready():
	Network.connect("received_packet", self, "_process_incoming_packet")
	pass

func _process_incoming_packet(content):
	var json = JSON.parse(content)
	var obj = json.result
	
	# 100 - 109 => Initial Connection
	# 110 - 119 => Reflexe Button
	# 120 - 129 => Wheel Buttons

	match int(obj["code"]):
		200:
			# Recive Response
			if bool(obj["value"]) == true:
				send_packet_value(101, username)
				get_tree().change_scene("res://Scenes/Lobby.tscn")
		201:
			# Receive Color
			var color_dict = obj["value"]
			print(color_dict)
			var color = Color(color_dict["r"], color_dict["g"], color_dict["b"], 1)
			print(color)
			Global.color = color
			emit_signal("update_color")
			
		210:
			# Switch to Reflex Button
			return
		220:
			# Switch to Driving Buttons
			get_tree().change_scene("res://Scenes/CarControl.tscn")

func send_packet(code):
	var dict = {}
	dict["code"] = code
	Network.send_packet(JSON.print(dict))
	
func send_packet_value(code, value):
	var dict = {}
	dict["code"] = code
	dict["value"] = value
	Network.send_packet(JSON.print(dict))
