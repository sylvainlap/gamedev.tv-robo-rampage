class_name Enemy
extends CharacterBody3D

const SPEED = 5.0

@export var aggro_range: float = 12.0
@export var attack_range: float = 1.5
@export var max_hitpoints: int = 100
@export var attack_damage: int = 20

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _player: CharacterBody3D
var _provoked: bool = false
var _distance: float
var hitpoints: int = max_hitpoints:
	set(value):
		_provoked = true
		hitpoints = value
		if hitpoints <= 0:
			queue_free()


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("Player")


func _process(_delta: float) -> void:
	_distance = global_position.distance_to(_player.global_position)
	
	if _distance <= aggro_range:
		_provoked = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if _provoked:
		navigation_agent_3d.target_position = _player.global_position
		var next_position = navigation_agent_3d.get_next_path_position()
		
		var direction = global_position.direction_to(next_position)
		
		if _distance <= attack_range:
			animation_player.play("attack")

		if direction:
			_look_at_target(direction)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)
	

func _attack() -> void:
	_player.hitpoints -= attack_damage
