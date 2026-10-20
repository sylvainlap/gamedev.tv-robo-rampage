class_name Player
extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.001
@export var jump_height: float = 1.0
@export var fall_multiplier: float = 2.5
@export var max_hitpoints: int = 100
@export var aim_multiplier: float = 0.7

var _mouse_motion: Vector2 = Vector2.ZERO
var hitpoints: int = max_hitpoints:
	set(value):
		if value < hitpoints:
			damage_animation_player.stop()
			damage_animation_player.play("take_damage")
		hitpoints = value
		if hitpoints <= 0:
			game_over_menu.game_over()

@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTextureRect/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var ammo_handler: AmmoHandler = %AmmoHandler
@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var smooth_camera_fov: float = smooth_camera.fov
@onready var weapon_camera: Camera3D = %WeaponCamera
@onready var weapon_camera_fov: float = weapon_camera.fov


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		smooth_camera.fov = lerp(smooth_camera.fov, smooth_camera_fov * aim_multiplier, delta * 20.0)
		weapon_camera.fov = lerp(weapon_camera.fov, weapon_camera_fov * aim_multiplier, delta * 20.0)
	else:
		smooth_camera.fov = lerp(smooth_camera.fov, smooth_camera_fov, delta * 30.0)
		weapon_camera.fov = lerp(weapon_camera.fov, weapon_camera_fov, delta * 30.0)


func _physics_process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		handle_camera_rotation()
	
	if not is_on_floor():
		if velocity.y >= 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * fall_multiplier

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2 * -get_gravity().y)

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if Input.is_action_pressed("aim"):
			velocity.x *= aim_multiplier
			velocity.z *= aim_multiplier
			
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion = -event.relative * mouse_sensitivity
		
		if Input.is_action_pressed("aim"):
			_mouse_motion *= aim_multiplier
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func handle_camera_rotation() -> void:
	rotate_y(_mouse_motion.x)
	camera_pivot.rotate_x(_mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90.0, 90.0)
	_mouse_motion = Vector2.ZERO
