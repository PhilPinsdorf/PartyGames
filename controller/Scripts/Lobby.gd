extends Control

func _ready():
	PacketManager.connect("update_color", self, "_update_color")
	pass
	
func _update_color():
	print("Color Update")
	$Background.self_modulate = Global.color
	update()
