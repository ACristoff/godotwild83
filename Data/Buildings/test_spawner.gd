extends Building

@export var item_spawn : PackedScene = null

var main_belt : Belt = null

@onready var cell : Vector2 = Grid.calculate_grid_coordinates(position)
@onready var level = get_parent()

@onready var icon = $Icon
var dir : Vector2 = Vector2.RIGHT

func _ready():
	#Check for a surrounding belt
	var auxCell : Vector2 = cell
	var pos
	
	for i in range(0,4):
		#Calculate position
		auxCell = cell + level.DIRECTIONS[i] #Check all directions
		pos = level.map.get(auxCell)
		
		#Check if there's a belt in the position
		if(pos != null):
			if pos is Belt:
				main_belt = pos
				pos.conn_building = self
				break
	pass
	
func _process(delta):
	#If there's a belt connected to the spawner
	if(main_belt != null):
		#If the belt doesn't have a connected item
		if(main_belt.item_held == null):
			#Spawn an item on the belt
			var item = item_spawn.instantiate()
			main_belt.item_held = item
			item.parent_belt = main_belt
			item.target_belt = main_belt.next_belt
			main_belt.add_child(item)
			main_belt.move_item()
