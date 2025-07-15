extends Node2D
class_name Belt

var item_held : ItemTest = null
var items_passed = 0

var speed = 10

## Level reference
## The level should always be the parent of the object
@onready var level = get_parent() #this is just for clarity in the code

## Position in the cell grid
@onready var cell : Vector2 = Grid.calculate_grid_coordinates(position)

var next_belt : Belt = null

@onready var raycast2d = $RayCast2D

func _ready():
	#Check for surrounding belts
	var auxCell : Vector2 = cell
	var pos
	
	for i in range(0,4):
		#Calculate position
		auxCell = cell + level.DIRECTIONS[i] #Check all directions
		pos = level.map.get(auxCell)
		
		#Check if there's a belt in the position
		if(pos != null):
			next_belt = pos
			break

func _process(delta):
	if item_held != null:
		item_held.transform.x += speed
	pass
