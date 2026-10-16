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


func _equip(active_weapon: Node3D) -> void:
	for weapon in get_children():
		if weapon == active_weapon:
			weapon.visible = true
			weapon.set_process(true)
		else:
			weapon.visible = false
			weapon.set_process(false)
