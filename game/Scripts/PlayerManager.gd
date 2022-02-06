extends Node

const MAX_PLAYERS = 4

var user_id_assignment = {}

func add_user(id, username):
	user_id_assignment[id] = username
	
func remove_user(id):
	user_id_assignment[id] = null
	
func user_count():
	user_id_assignment.size()
	

