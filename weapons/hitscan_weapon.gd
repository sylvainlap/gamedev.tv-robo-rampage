extends Node3D

@export var weapon_damage: int = 15
@export var fire_rate: float = 14.0
@export var recoil: float = 0.05
@export var weapon_mesh: Node3D
@export var muzzle_flash: GPUParticles3D
@export var sparks_scene: PackedScene
@export var automatic: bool = false

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
	if automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				_shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				_shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)


func _shoot() -> void:
	cooldown_timer.start(1.0 / fire_rate)
	muzzle_flash.restart()
	weapon_mesh.position.z += recoil
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider is Enemy:
			collider.hitpoints -= weapon_damage
		var sparks = sparks_scene.instantiate()
		add_child(sparks)
		sparks.global_position = ray_cast_3d.get_collision_point()
