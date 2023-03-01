extends Node3D

class_name SlidingDoor

@onready
var door_object: Node3D = $sliding_door

@onready
var door_start_local_vector: Vector3 = $sliding_door.position

var default_slide_time: float = 4.5

func slide_to_vector(target_vector: Vector3, time: float = default_slide_time):
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	#$AudioStreamPlayer3D.play()
	tween.tween_property(door_object, "position", target_vector, time)

func slide_to_start_vector():
	slide_to_vector(door_start_local_vector)

func slide_by_vector(target_vector: Vector3, time: float = default_slide_time):
	slide_to_vector(door_object.position + target_vector, time)

func _ready() -> void:
	await get_tree().create_timer(6).timeout
	slide_by_vector(Vector3(0, 8, 0))
	await get_tree().create_timer(6).timeout
	slide_to_start_vector()
	await get_tree().create_timer(6).timeout
	slide_by_vector(Vector3(0, 8, 0))
	await get_tree().create_timer(6).timeout
	slide_to_start_vector()
