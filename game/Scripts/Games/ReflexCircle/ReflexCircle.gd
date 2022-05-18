extends Node2D

var positions = []

func _ready():
	positions = $SpawnPositions.get_children()
	
	var player = preload("res://Scenes/Games/ReflexCircle/CirclePlayer.tscn")
	for id in PlayerManager.user_ids:
		# Spawn player
		var spot = PlayerManager.id_spot_assignment[id]
		var pos = positions[spot].global_position
		var rot = positions[spot].global_rotation
		Global.instance_node_at_loc_rot_name_color(player, $Player, pos, rot, str(id), spot)
		positions.remove(0)
	
	check_win()
	pass

func _draw():
	var circle_center = get_viewport_rect().size / 2
	draw_arc(circle_center, 400, 0, TAU, 100, Color(1, 1, 1))
	pass


func _on_collision_detected(body):
	if(PlayerManager.user_ids.has(str(body.name))):
		body.queue_free()
		check_win()
		pass
	pass

func check_win():
	if $Player.get_child_count() == 1:
		GameManager.finish_game($Player.get_child(0).name)
