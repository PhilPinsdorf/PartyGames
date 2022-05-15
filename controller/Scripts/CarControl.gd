extends Control

func _ready():
	$Background.self_modulate = Global.color
	update()
	pass

func _on_Left_button_down():
	PacketManager.send_packet(120)
	pass 

func _on_Left_button_up():
	PacketManager.send_packet(121)
	pass 

func _on_Right_button_down():
	PacketManager.send_packet(122)
	pass 

func _on_Right_button_up():
	PacketManager.send_packet(123)
	pass 
