extends Control

func _ready():
	$Background.self_modulate = Global.color
	update()
	pass

func _on_Button_button_down():
	PacketManager.send_packet(110)
	pass 


func _on_Button_button_up():
	PacketManager.send_packet(111)
	pass
