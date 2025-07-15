extends Node2D

class_name Level

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

#@export var grid: Resource = preload("res://Lib/Grid/grid.tres")
@export var level_music: AudioStreamMP3
@export var confirm_sfx: AudioStreamMP3
@export var deselect_sfx: AudioStreamMP3
@export var invalid_sfx: AudioStreamMP3

@export var building_glossary = [preload("res://Data/Buildings/base_building.tscn")]

var map := {}

#var currently_building = null
var current_building = building_glossary[0]

func reinitialize():
	for child in get_children():
		#var unit := child as Unit
		#if not unit:
			#continue
		pass

func place_building(cell):
	#Early exit if the placement is invalid
	if !is_valid_placement(cell):
		return false
	#Instantiate the selected building
	var new_building = current_building.instantiate()
	#Place it
	var building_position = Grid.calculate_map_position(cell)
	new_building.position = building_position
	add_child(new_building)
	pass

func is_valid_placement(cell):
	#TODO Check the buildings map if cell is blocked or in bounds, then return false if it is. 
	#Otherwise return true
	return true

func _on_cursor_accept_pressed(cell):
	#print('cursor selected:', cell)
	if current_building != null:
		place_building(cell)
	pass # Replace with function body.


func _on_cursor_moved_cursor(new_cell):
	#print('cursor moved to:', new_cell)
	pass # Replace with function body.
