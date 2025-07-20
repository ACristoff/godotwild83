extends CharacterBody2D
class_name ItemTest

var moving = false

var parent_belt : Belt
var target_belt : Belt

func _physics_process(delta):
	if moving:
		move_and_slide()
	#If reached next belt, move object to next belt
	if target_belt != null:
		if global_position.distance_to(target_belt.global_position) <= 0.5:
			pass_item()

## Passes item to next belt
func pass_item():
	#Check if there's space on target belt
	if target_belt.item_held == null or (target_belt.item_held != null and target_belt.item_held.moving):
		#Take item off belt
		parent_belt.item_held = null
		parent_belt = target_belt
		
		#Place item on new belt
		reparent(parent_belt)
		parent_belt.item_held = self
		parent_belt.move_item()
		target_belt = parent_belt.next_belt
	#If there's no space, stop moving
	else:
		velocity = Vector2.ZERO
		moving = false
