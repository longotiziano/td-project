extends Node

@export var max_stamina:  float = 100.0
@export var drain_speed:  float = 20.0
@export var regen_speed:  float = 10.0

var stamina: float = 100.0

func drain(delta: float):
	stamina = clamp(stamina - drain_speed * delta, 0, max_stamina)

func regen(delta: float):
	stamina = clamp(stamina + regen_speed * delta, 0, max_stamina)

func is_empty() -> bool:
	return stamina <= 0
