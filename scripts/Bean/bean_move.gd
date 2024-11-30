extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed:int = 5
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration:int = 75

@onready var camera_pivot_x:Node3D = %CameraPivotX

var target_velocity:Vector3 = Vector3.ZERO
var mouse_sensitivity:float= .2
var mouse_position:Vector2

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("right_click") || Input.is_action_just_pressed("middle_mouse_click"):
		
		mouse_position = get_viewport().get_mouse_position()
	
	if event is InputEventMouseMotion && (Input.is_action_pressed("right_click") || Input.is_action_just_pressed("middle_mouse_click")):
		
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$BeanModel.rotate_y(deg_to_rad(event.relative.x * mouse_sensitivity))
		camera_pivot_x.rotate_x(deg_to_rad(event.relative.y * mouse_sensitivity))

	if Input.is_action_just_released("right_click") || Input.is_action_just_released("middle_mouse_click"):
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.warp_mouse(mouse_position)
	
	#TODO make the movement based on the camera angle, no x+1 thats for loser babies who should feel bad for using it 
	# also clamp camera, no 360 spins 


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
	
	camera_pivot_x.rotation_degrees.x = clampf(camera_pivot_x.rotation_degrees.x, -75, 50.0)
	
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
