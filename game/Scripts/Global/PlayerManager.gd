extends Node

const MAX_PLAYERS = 4
const MIN_START_PLAYERS = 1

var avalibleSpots = [0, 1, 2, 3]
var user_ids = []
var id_spot_assignment = {}
var id_user_assignment = {}
var id_color_assignment = {}

func add_user(id, username):
	var spot = avalibleSpots[0]
	avalibleSpots.remove(0)
	id_spot_assignment[str(id)] = spot
	
	user_ids.append(str(id))
	id_user_assignment[str(id)] = username
	
	var color = Global.avalibleColors[spot]
	id_color_assignment[str(id)] = color
	
	return spot

func remove_user(id):
	if user_ids.has(str(id)):
		var spot = id_spot_assignment[str(id)]
		avalibleSpots.push_front(spot)
		id_spot_assignment.erase(str(id))
		id_color_assignment.erase(str(id))
		user_ids.erase(str(id))
		id_user_assignment.erase(str(id))

func user_count():
	return user_ids.size()

func get_color_id(id):
	return id_color_assignment[id]

func get_id_from_spot(spot):
	for key in id_spot_assignment.keys():
		if id_spot_assignment[key] == spot:
			return key
	return null

