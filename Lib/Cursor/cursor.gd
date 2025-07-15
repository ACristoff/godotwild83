extends Node2D

class_name Cursor

## Grid resource, giving the node access to the grid size, and more.
#@export var grid: Resource

## Time before the cursor can move again in seconds.
@export var ui_cooldown := 0.1

@onready var _timer: Timer = $Timer
@onready var cursor_sprite = $Sprite2D

## Emitted when clicking on the currently hovered cell or when pressing "confirm"
signal accept_pressed(cell)
## Emitted when the cursor moved to a new cell.
signal moved_cursor(new_cell)
## Emitted when deselecting
signal deselect_pressed()

## Item to be placed by the cursor
var placed_item = null
## References to the buttons (temporary, delete this later)
@onready var belt = $"../UI/Belt"
@onready var spawner = $"../UI/Spawner"

## Coordinates of the current cell the cursor is hovering.
var cell := Vector2.ZERO:
	set(value):
		# We first clamp the cell coordinates and ensure that we aren't
		#	trying to move outside the grid boundaries
		var new_cell: Vector2 = Grid.grid_clamp(value)
		if new_cell.is_equal_approx(cell):
			return

		cell = new_cell
		# If we move to a new cell, we update the cursor's position, emit
		#	a signal, and start the cooldown timer that will limit the rate
		#	at which the cursor moves when we keep the direction key held
		#	down
		position = Grid.calculate_map_position(cell)
		#TODO
		emit_signal("moved_cursor", cell)
		_timer.start()

func _ready() -> void:
	_timer.wait_time = ui_cooldown
	position = Grid.calculate_map_position(cell)

var awake = true
var d := 1.0
@export var bob_height := 5
@export var bob_speed := 2
@export var cursor_offset_y := -45

func _process(delta):
	if awake == true:
		d += delta
		cursor_sprite.position = Vector2(
			0,
			sin(d * bob_speed) * bob_height + cursor_offset_y
		)
	pass

func _input(event: InputEvent) -> void:
	# Navigating cells with the mouse.
	if event is InputEventMouseMotion:
		cell = Grid.calculate_grid_coordinates(event.position + Vector2(0, 0))
	# Trying to select something in a cell.
	elif event.is_action_pressed("confirm") or event.is_action_pressed("ui_accept"):
		#emit_signal("accept_pressed", cell)
		#get_viewport().set_input_as_handled()
		if placed_item != null:
			var item = placed_item.instantiate()
			item.global_position = Grid.calculate_map_position(cell)
			var level = get_parent() #Parent is the level
			level.add_child(item) 
			level.map.set(cell, item)
			
	elif event.is_action_pressed("right_click"):
		#TODO
		#deselect_pressed.emit()
		pass
	var should_move := event.is_pressed() 
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()

	if not should_move:
		return

	# Moves the cursor by one grid cell.
	if event.is_action("ui_right"):
		cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		cell += Vector2.UP
	elif event.is_action("ui_left"):
		cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		cell += Vector2.DOWN

func _draw() -> void:
	draw_rect(Rect2(-Grid.cell_size / 2, Grid.cell_size), Color.ALICE_BLUE, false, 2.0)

func _on_belt_toggled(toggled_on):
	if toggled_on:
		placed_item = load("res://Data/Buildings/ConveyorBelt.tscn")
		spawner.set_pressed_no_signal(false)
	else:
		placed_item = null

func _on_spawner_toggled(toggled_on):
	if toggled_on:
		placed_item = load("res://Data/Buildings/TestSpawner.tscn")
		belt.set_pressed_no_signal(false)
	else:
		placed_item = null
