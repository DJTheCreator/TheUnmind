extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 5
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO

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
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
