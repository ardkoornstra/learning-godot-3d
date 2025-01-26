extends RigidBody3D

@export var thrust: float = 1000.0
@export var torqueThrust: float = 100.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("Boost"):
		apply_central_force(basis.y * delta * 1000.0)
	if Input.is_action_pressed("Left"):
		apply_torque(Vector3(0.0, 0.0, torqueThrust * delta))
	if Input.is_action_pressed("Right"):
		apply_torque(Vector3(0.0, 0.0, -torqueThrust * delta))


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Goal"):
		print("OwO")
	elif body.is_in_group("Hazard"):
		print("aaaaaaaaAAAAAAAAAAAAAAAAA")
