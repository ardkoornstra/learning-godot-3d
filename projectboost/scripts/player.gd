extends RigidBody3D

@export var thrust: float = 1000.0
@export var torqueThrust: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var win_audio: AudioStreamPlayer = $WinAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_left: GPUParticles3D = $BoosterParticlesLeft
@onready var booster_particles_right: GPUParticles3D = $BoosterParticlesRight
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

func _process(delta: float) -> void:
	if Input.is_action_pressed("Boost"):
		apply_central_force(basis.y * delta * 1000.0)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
	if Input.is_action_pressed("Left"):
		apply_torque(Vector3(0.0, 0.0, torqueThrust * delta))
		booster_particles_right.emitting = true
	else:
		booster_particles_right.emitting = false
	if Input.is_action_pressed("Right"):
		apply_torque(Vector3(0.0, 0.0, -torqueThrust * delta))
		booster_particles_left.emitting = true
	else:
		booster_particles_left.emitting = false


func _on_body_entered(body: Node) -> void:
	if !is_transitioning:
		if body.is_in_group("Goal"):
			win(body.filePath)
		elif body.is_in_group("Hazard"):
			crash()

func crash() -> void:
	reset()
	print("aaaaAAAAAAAAA")
	explosion_particles.emitting = true
	explosion_audio.play()
	var tween = create_tween()
	tween.tween_interval(explosion_audio.stream.get_length())
	tween.tween_callback(get_tree().reload_current_scene)

func win(nextLevel: String) -> void:
	reset()
	print("OwO")
	success_particles.emitting = true
	win_audio.play()
	var tween = create_tween()
	tween.tween_interval(win_audio.stream.get_length())
	tween.tween_callback(get_tree().change_scene_to_file.bind(nextLevel))
	
func reset() -> void:
	set_process(false)
	rocket_audio.stop()
	booster_particles.emitting = false
	booster_particles_left.emitting = false
	booster_particles_right.emitting = false
	is_transitioning = true
