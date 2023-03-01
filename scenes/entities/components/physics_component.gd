extends Component

class_name PhysicsComponent

@export var gravity: float = 34.0

# Not sure if I'll use this. But just in case
@export var inertia: float = 0.0

@export var speed: float = 5.0

@export var launch_velocity: float = 10.5

func _init() -> void:
	super()
	id = "Physics"
