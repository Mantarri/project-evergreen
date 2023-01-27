extends CharacterBody3D

class_name Entity

const SPEED = 5.0
const JUMP_VELOCITY = 7.75


@export
var mouse_sensitivity: float = 0.075
var direction: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 17.64

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("action_primary") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		$Camera3D.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90.0, 90.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
#		velocity.x = 0
#		velocity.z = 0
	
	move_and_slide()
