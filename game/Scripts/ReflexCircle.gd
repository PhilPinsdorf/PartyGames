extends Node2D

var positions = []

func _ready():
	positions = $SpawnPositions.get_children()
	
	var car = preload("res://Scenes/Games/ReflexCircle/CirclePlayer.tscn")
	for id in PlayerManager.user_ids:
		# Spawn player
		var pos = positions[0].global_position
		var rot = positions[0].global_rotation
		var spot = PlayerManager.id_spot_assignment[id]
		Global.instance_node_at_loc_rot_name_color(car, $Player, pos, rot, str(id), spot)
		positions.remove(0)
	pass

func _draw():
	var circle_center = get_viewport_rect().size / 2
	draw_arc(circle_center, 400, 0, TAU, 100, Color(1, 1, 1))
	pass
