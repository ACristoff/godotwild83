extends Node

class_name Game_Manager

##Game Manager:
##This node is not necessarily meant to be an autoload, but rather sit at the top of the node hierarchy
##Nodes get switched out as children of this node and this is where game-wide data is stored
##By default, you'd put the node configuration of what is meant to run on launch and have things loop back to main menu

@export var debug_mode: bool = false

@onready var menu_ui: CanvasLayer = $MenuUI
@onready var splash: Control = $Transitions/Splash

@onready var main_menu = preload("res://UI/Menus/Main_Menu/main_menu.tscn")
@onready var settings_menu
@onready var credits_menu
@onready var game = preload("res://Lib/Level_Manager/level.tscn")

#@onready var current_menu = $Transitions/Splash

@onready var Menu_Scenes: Dictionary = {
	"Main": main_menu,
	"Start": game,
	"Settings": 'NOT DONE YET BOZO',
	"Credits": 'NOT DONE YET BOZO',
	"Pause": 'NOT DONE YET BOZO',
	"Quit": 'Quit za gameo'
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.game_state_changed.connect(change_scene.bind())
	if debug_mode == true:
		SignalBus.game_state_changed.emit("Main")
		splash.queue_free()
	

func change_scene(new_state: String):
	if debug_mode == true:
		prints('scene changed', new_state, Menu_Scenes[new_state])
	if new_state == "Quit":
		get_tree().quit()
	if new_state == "Start":
		var new_scene = Menu_Scenes[new_state].instantiate()
		add_child(new_scene)
		menu_ui.get_child(0).queue_free()
		return
	if Menu_Scenes[new_state] is not String:
		var new_scene = Menu_Scenes[new_state].instantiate()
		menu_ui.add_child(new_scene)
	
