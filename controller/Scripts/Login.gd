extends Control

onready var username = $Background/UserNameEdit

func _ready():
	pass

func _on_JoinButton_pressed():
	if username.text != "":
		PacketManager.send_packet(100)
		PacketManager.username = username.text
	pass 
