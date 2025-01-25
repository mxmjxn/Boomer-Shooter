extends CharacterBody3D

@export var move_speed = 5.0
@export var mouse_sensitivity = 0.1
@export var jump_strength = 7.5

var vel = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity * 0.01)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity * 0.01)
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90, 90)

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1

	input_dir = input_dir.normalized()

	# Calculate movement direction based on player orientation
	var direction = (transform.basis.x * input_dir.x) + (transform.basis.z * input_dir.z)
	vel.x = direction.x * move_speed
	vel.z = direction.z * move_speed
	
	if is_on_floor() and Input.is_action_just_pressed("move_jump"):
		vel.y = jump_strength
		
	vel.y += -15 * delta # Adjusted Gravity to have a faster falling speed ( TUNE )
	
	velocity = vel
	move_and_slide()
