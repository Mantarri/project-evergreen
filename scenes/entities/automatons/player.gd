extends CharacterBody3D

class_name Entity

var speed: float = 5.0
var jump_velocity = 7.0

@onready
var component_holder: ComponentHolder = $ComponentHolder

@export
var mouse_sensitivity: float = 0.075
var direction: Vector3

@onready
var camera: Camera3D = $Camera3D

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
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90.0, 90.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _process(_delta: float) -> void:
	if direction:
		if not $AudioStreamPlayer3D.playing and is_on_floor():
			$AudioStreamPlayer3D.play()
		
		#if not $AnimationPlayer.is_playing():
		#	$AnimationPlayer.play("camera_bob")
	
	
	
	elif direction == Vector3.ZERO:
		$AnimationPlayer.play("RESET")
		var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		await tween.tween_property($AudioStreamPlayer3D, "volume_db", -6, 0.5).finished
		$AudioStreamPlayer3D.stop()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= component_holder.get_component_member("Physics", "gravity") * delta
	
	# Handle Jump.
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = component_holder.get_component_member("Physics", "launch_velocity")
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Input.is_action_pressed("move_sprint"):
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(camera, "fov", 90, .2)
			$AnimationPlayer.speed_scale = 1.5
			velocity.x = direction.x * (speed + 3.0)
			velocity.z = direction.z * (speed + 3.0)
		else:
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(camera, "fov", 75, .1)
			$AnimationPlayer.speed_scale = 1.0
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
