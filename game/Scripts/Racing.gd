extends Node2D

var positions = []

func _ready():
	Network.connect("client_connected", self, "_on_new_client")
	
	# Load Map
	
	positions = $Map/SpawnPositions.get_children()
	pass
	
func _on_new_client(id):
	var node = preload("res://Scenes/Racing/Car.tscn")
	var pos = positions[0].global_position
	var rot = positions[0].global_rotation
	Global.instance_node_at_loc_rot_name(node, self, pos, rot, str(id))
	positions.remove(0)
	pass
