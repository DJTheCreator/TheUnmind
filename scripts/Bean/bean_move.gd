extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed:int = 5
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration:int = 75

@onready var camera_pivot_x:Node3D = %CameraPivotX

var target_velocity:Vector3 = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed("right_click"):
		rotate_y(deg_to_rad(-event.relative.x * .2))
		$BeanModel.rotate_y(deg_to_rad(event.relative.x * .2))
		camera_pivot_x.rotate_x(deg_to_rad(event.relative.y * .2))
		# To get mouse to not move while holding right click use Input.mouse_mode = Input.MOUSE_MODE_CAPTURE
		# Set the mouse mode back to MOUSE_MODE_VISIBLE (the default setting) after you release right click
		# You just need to check where the mouse is before they hold down right click and then 
		# teleport the mouse back to that position after they release right click. Use Input.warp_mouse(pos)


#func cameraControl():
	
	#var mouse_current_position:Vector2 = get_viewport().get_mouse_position()
	#var mouse_previous_position:Vector2
	#
	#if Input.is_action_pressed("right_click"):
		#
		#if mouse_current_position.x < mouse_previous_position.x:
			#camera_pivot.rotate_y(deg_to_rad(.5))
		#if mouse_current_position.x > mouse_previous_position.x:
			#camera_pivot.rotate_y(deg_to_rad(-.5))
			#
		#if mouse_current_position.y < mouse_previous_position.y:
			#camera_pivot.rotate_x(deg_to_rad(-.5))
		#if mouse_current_position.y > mouse_previous_position.y:
			#camera_pivot.rotate_x(deg_to_rad(.5))
	#
	#mouse_previous_position = mouse_current_position

#func _process(delta: float) -> void:
	#cameraControl()

func _physics_process(delta):
	var direction:Vector3 = Vector3.ZERO

	if Input.is_action_pressed("D_input"):
		direction.x += 1
	if Input.is_action_pressed("A_input"):
		direction.x -= 1
	if Input.is_action_pressed("S_input"):
		direction.z += 1
	if Input.is_action_pressed("W_input"):
		direction.z -= 1
		
	if Input.is_action_pressed("space_press"):
		direction.y += 1


	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	target_velocity.y += direction.y * speed

	# Vertical Velocity
	if !is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()


#https://docs.godotengine.org/en/4.3/classes/class_node3d.html
