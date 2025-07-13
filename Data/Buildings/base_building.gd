extends Node2D
class_name Building

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _timer: Timer = $Timer


enum direction {UP, DOWN, LEFT, RIGHT}

var current_direction = direction.UP

@export_group("Data")
@export var production_speed: float = 1
## Shared resource of type Grid, used to calculate map coordinates.
@export var grid: Resource
@export_group("Assets")
@export var building_sprite: Texture2D 

func _ready() -> void:
	_sprite.texture = building_sprite
	_timer.wait_time = production_speed
