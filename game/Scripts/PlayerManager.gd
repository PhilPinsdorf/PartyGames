extends Node

const MAX_PLAYERS = 4

var user_id_assignment = {}
var id_color_assignment = {}

func add_user(id, username):
	user_id_assignment[id] = username

func add_user_random_color(id, count):
	var color = Global.avalibleColors[count]
	id_color_assignment[id] = color

func remove_user(id):
	user_id_assignment[id] = null
	
func user_count():
	return user_id_assignment.size()
	
func get_color_id(id):
	return id_color_assignment[id]

