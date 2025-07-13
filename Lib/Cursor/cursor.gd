extends Node2D

class_name Cursor

## Grid resource, giving the node access to the grid size, and more.
@export var grid: Resource

## Time before the cursor can move again in seconds.
@export var ui_cooldown := 0.1

@onready var _timer: Timer = $Timer
@onready var cursor_sprite = $Sprite2D

## Coordinates of the current cell the cursor is hovering.
var cell := Vector2.ZERO:
	set(value):
		# We first clamp the cell coordinates and ensure that we aren't
		#	trying to move outside the grid boundaries
		var new_cell: Vector2 = grid.grid_clamp(value)
		if new_cell.is_equal_approx(cell):
			return

		cell = new_cell
		# If we move to a new cell, we update the cursor's position, emit
		#	a signal, and start the cooldown timer that will limit the rate
		#	at which the cursor moves when we keep the direction key held
		#	down
		position = grid.calculate_map_position(cell)
		emit_signal("moved", cell)
		_timer.start()
