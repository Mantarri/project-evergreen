extends CharacterBody3D

class_name Entity

const SPEED = 5.0
const JUMP_VELOCITY = 7.75


@export
var mouse_sensitivity: float = 0.075

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
		$Camera3D.rotation.x -= deg_to_rad(event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = deg_to_rad(clamp(rad_to_deg($Camera3D.rotation.x), -90.0, 90.0))
		
		rotation.y -= deg_to_rad(event.relative.x * mouse_sensitivity)
		rotation.y = deg_to_rad(wrapf(rad_to_deg(rotation.y), 0.0, 360.0))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
