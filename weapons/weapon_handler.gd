extends Node3D

@export var smg: Node3D
@export var rifle: Node3D


func _ready() -> void:
	_equip(smg)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("smg"):
		_equip(smg)
	if event.is_action_pressed("rifle"):
		_equip(rifle)
	if event.is_action_pressed("next_weapon"):
		_next_weapon()
	if event.is_action_pressed("previous_weapon"):
		_previous_weapon()


func _equip(active_weapon: Node3D) -> void:
	for weapon in get_children():
		if weapon == active_weapon:
			weapon.visible = true
			weapon.set_process(true)
			weapon.ammo_handler.update_ammo_label(weapon.ammo_type)
		else:
			weapon.visible = false
			weapon.set_process(false)


func _next_weapon() -> void:
	var index = _get_current_index()
	index = wrapi(index + 1, 0, get_child_count())
	var next_weapon = get_child(index)
	_equip(next_weapon)


func _previous_weapon() -> void:
	var index = _get_current_index()
	index = wrapi(index - 1, 0, get_child_count())
	var next_weapon = get_child(index)
	_equip(next_weapon)


func _get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible:
			return index
	
	return 0
