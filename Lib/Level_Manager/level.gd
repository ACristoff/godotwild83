extends Node2D

class_name Level

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@export var grid: Resource = preload("res://Lib/Grid/grid.tres")
@export var level_music: AudioStreamMP3

var buildings := {}


func reinitialize():
	for child in get_children():
		#var unit := child as Unit
		#if not unit:
			#continue
		pass
