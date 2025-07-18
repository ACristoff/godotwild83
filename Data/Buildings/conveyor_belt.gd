extends Node2D
class_name Belt

var item_held : ItemTest = null
var items_passed = 0

var speed = 1

## Level reference
## The level should always be the parent of the object
@onready var level = get_parent() #this is just for clarity in the code

## Position in the cell grid
@onready var cell : Vector2 = Grid.calculate_grid_coordinates(position)

## Next belt on line
var next_belt : Belt = null

## Connected building
var conn_building : Building = null

@onready var raycast2d = $RayCast2D
@onready var icon = $Icon

func _ready():
	#Check for surrounding buildings
	var auxCell : Vector2 = cell #Auxiliary cell for calculations
	var pos #Object in position
	var belt_conn = false #There's a belt connected to this
	var build_conn = false #There's a building connected to this
	for i in range(0,4):
		#Calculate position
		auxCell = cell + level.DIRECTIONS[i] #Check all directions
		pos = level.map.get(auxCell)
		
		#If there's a building
		if(pos != null):
			#Check if there's a belt in the position
			if pos is Belt and !belt_conn:
				next_belt = pos
				belt_conn = true
			#Check if there's a building in the position
			if pos is Building and !build_conn:
				conn_building = pos
				
				build_conn = true
			#If fully connected, exit
			if belt_conn and build_conn:
				break

func _process(delta):
	#If there's an item on the belt, move it
	if item_held != null:
		item_held.position.x += speed
	pass
