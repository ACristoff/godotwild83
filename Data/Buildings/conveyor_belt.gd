extends Node2D
class_name Belt

var item_held : ItemTest = null
var items_passed = 0

var speed = 50

## Level reference
## The level should always be the parent of the object
@onready var level = get_parent() #this is just for clarity in the code

## Position in the cell grid
@onready var cell : Vector2 = Grid.calculate_grid_coordinates(position)

## Next belt on line
var next_belt : Belt = null

## Direction of the belt
var dir : Vector2 = Vector2.RIGHT #Default to right

## Connected building
var conn_building : Building = null

@onready var icon = $Icon

func _ready():
	#Rotate based on direction
	rotation = dir.angle() + deg_to_rad(90)
	
	#Check for next belt
	var auxCell : Vector2 = cell #Auxiliary cell for calculations
	var pos #Object in position
	auxCell = cell + dir
	pos = level.map.get(auxCell)
	#If there's a building
	if(pos != null):
		#Check if there's a belt in the position
		if pos is Belt:
			#Set next belt as pos
			next_belt = pos
		#Check if there's a building in the position
		elif pos is Building:
			conn_building = pos
			
	#Check for surrounding belts
	for i in range(0,4):
		#Skip direction of the belt, I want to check the other 3 directions
		if level.DIRECTIONS[i] != dir:
			auxCell = cell + level.DIRECTIONS[i]
			pos = level.map.get(auxCell)
			
			if(pos != null):
				#Check if there's a belt in the position
				if pos is Belt:
					#If pos' direction equals this belt, by defininition this is the next belt of pos
					if pos.cell + pos.dir == cell:
						pos.next_belt = self
		pass

func _process(delta):
	#If there's an item on the belt, move it
	if item_held != null:
		if next_belt != null:
			#If there's space on next belt OR the item on next belt is moving
			if next_belt.item_held == null or (next_belt.item_held != null and next_belt.item_held.moving):
				move_item()
			#If there's no space on next belt, stop moving
			else:
				stop_item()
		else:
			#If there's no next belt, don't move item
			stop_item()
	#If there's no belt forward, check for a belt
	if next_belt == null:
		#If there's a belt in the direction this is aiming, set it as next belt
				#Check target cell
				var aux = level.map.get(cell + dir)
				if aux != null:
					if aux is Belt:
						next_belt = aux
	
func move_item():
	#print("move")
	if item_held != null:
		item_held.moving = true
		item_held.velocity = speed * dir
		item_held.target_belt = next_belt

func stop_item():
	#print("stop")
	if item_held != null:
		item_held.velocity = Vector2.ZERO
		item_held.moving = false
