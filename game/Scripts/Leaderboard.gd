extends Control

var gold = Color("#ffd700")
var silver = Color("#c0c0c0")
var bronze = Color("#bf8970")

func _ready():
	var player_scores : Dictionary = GameManager.scores.duplicate(true)
	var scores = player_scores.values()
	scores.sort()
	scores.invert()
	
	var numbering = []
	var current_place = 0
	var real_place = 0
	var last_score = -1
	
	for score in scores:
		real_place += 1
		if int(last_score) != int(score):
			current_place = real_place
		numbering.append(current_place)
		last_score = score
	
	for num in scores.size():
		var node = get_node("Places/{n}".format({"n": num}))
		var number_node = node.get_node("Number")
		var username_node = node.get_node("Username")
		# var score_node = node.get_node("Score")
		var number = numbering[0]
		numbering.remove(0)
		number_node.set_text(str(number) + ". ")
		
		match number:
			1: number_node.add_color_override("font_color", gold)
			2: number_node.add_color_override("font_color", silver)
			3: number_node.add_color_override("font_color", bronze)
		
		for id in player_scores.keys():
			var score = player_scores[id]
			if score == scores[num]:
				var username = PlayerManager.id_user_assignment[id]
				var color = PlayerManager.id_color_assignment[id]
				username_node.set_text(username)
				username_node.add_color_override("font_color", color)
				player_scores.erase(id)
				break 
	pass
