extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var player: CharacterBody3D
var provoked: bool = false
var aggro_range: float = 12.0


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	print(distance)
	
	if distance <= aggro_range:
		provoked = true
	else:
		provoked = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if provoked:
		navigation_agent_3d.target_position = player.global_position
		var next_position = navigation_agent_3d.get_next_path_position()
		
		var direction = global_position.direction_to(next_position)

		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
