extends Node2D
class_name Building

@onready var _sprite: Sprite2D = $PathFollow2D/Sprite

enum direction {UP, DOWN, LEFT, RIGHT}

var current_direction = direction.UP

## Shared resource of type Grid, used to calculate map coordinates.
@export var grid: Resource
