extends Node2D

var positions = []
var clocks = {}
var finalTime = {}
var started = true

var ms = 0
var s = 0

var timeToMatch = 0

func _ready():
	PacketManager.connect("button_pressed", self, "_on_button_action")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	timeToMatch = rng.randi_range(15, 30)
	
	$Control/Label.text = "Try to get as close as\npossible to " + str(timeToMatch) + " Seconds!" 
	
	positions = $SpawnPositions.get_children()
	
	var clock = preload("res://Scenes/Games/Timer/TimerClock.tscn")
	for id in PlayerManager.user_ids:
		# Spawn player
		var pos = positions[0].global_position
		var rot = positions[0].global_rotation
		var spot = PlayerManager.id_spot_assignment[id]
		Global.instance_node_at_loc_rot_name_color_child(clock, $Clocks, pos, rot, str(id), spot, "Body/Light")
		positions.remove(0)
	
	for node in $Clocks.get_children():
		clocks[str(node.name)] = node
	
	yield(get_tree().create_timer(5.0), "timeout")
	for node in $Clocks.get_children():
		node.get_node("Labels").visible = false
	pass

func _on_button_action(id, action):
	print(!finalTime.has(str(id)))
	if (!finalTime.has(str(id))) && s > 5 && action == 0:
		finalTime[str(id)] = s * 10 + ms
		clocks[str(id)].get_node("Now").visible = true
		clocks.erase(str(id))
	
		if clocks.size() == 0:
			stop_game()
	pass

func _on_Timer_timeout():
	if started:
		ms += 1
		
		if(ms > 9):
			ms = 0
			s += 1
		
		for label in clocks.values():
			label.get_node("Labels/SecondsBack").text = str(s%10)
			label.get_node("Labels/SecondsFront").text = str(floor(s/10))
			label.get_node("Labels/MilliSeconds").text = str(ms)
		
		if s == 60:
			for id in PlayerManager.user_ids:
				if !finalTime.has(str(id)):
					finalTime[str(id)] = 60 * 10
			
			stop_game()
	pass

func stop_game():
	started = false
	for node in $Clocks.get_children():
		node.get_node("Labels").visible = true
		node.get_node("Now").visible = false
	
	print(finalTime)
	
	for id in PlayerManager.user_ids:
		finalTime[str(id)] = abs(timeToMatch * 10 - finalTime[str(id)])
	
	var scores = finalTime.values()
	scores.sort()
	
	print(scores)
	
	# TODO: Handle if two players have same Time
	
	for id in PlayerManager.user_ids:
		if finalTime[str(id)] == scores[0]:
			GameManager.finish_game(str(id))
	pass
