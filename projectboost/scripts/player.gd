extends RigidBody3D

@export var thrust: float = 1000.0
@export var torqueThrust: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var win_audio: AudioStreamPlayer = $WinAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio

func _process(delta: float) -> void:
	if Input.is_action_pressed("Boost"):
		apply_central_force(basis.y * delta * 1000.0)
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		rocket_audio.stop()
	if Input.is_action_pressed("Left"):
		apply_torque(Vector3(0.0, 0.0, torqueThrust * delta))
	if Input.is_action_pressed("Right"):
		apply_torque(Vector3(0.0, 0.0, -torqueThrust * delta))


func _on_body_entered(body: Node) -> void:
	if !is_transitioning:
		if body.is_in_group("Goal"):
			win(body.filePath)
		elif body.is_in_group("Hazard"):
			crash()

func crash() -> void:
	print("aaaaAAAAAAAAA")
	rocket_audio.stop()
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(explosion_audio.stream.get_length())
	tween.tween_callback(get_tree().reload_current_scene)

func win(nextLevel: String) -> void:
	print("OwO")
	rocket_audio.stop()
	win_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(win_audio.stream.get_length())
	tween.tween_callback(get_tree().change_scene_to_file.bind(nextLevel))
