extends Node

const colorRed = Color8(255, 80, 80)
const colorBlue = Color8(80, 80, 255)
const colorYellow = Color8(255, 255, 80)
const colorGreen = Color8(80, 255, 80)
const avalibleColors = [colorRed, colorBlue, colorYellow, colorGreen]

func instance_node_at_loc_rot_name(node: Object, parent: Object, location: Vector2, rotation: float, newname: String) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	node_instance.global_rotation = rotation
	node_instance.name = newname
	return node_instance

func instance_node_at_loc_rot(node: Object, parent: Object, location: Vector2, rotation: float) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	node_instance.global_rotation = rotation
	return node_instance

func instance_node_at_loc(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance
	

