extends Camera3D

var target: Node3D
var zoom_level:   float = 20.0
var current_zoom: float = 20.0

@export var zoom_speed:  float = 1.0
@export var zoom_min:    float = 5.0
@export var zoom_max:    float = 40.0
@export var zoom_smooth: float = 8.0  # qué tan suave, más alto = más rápido

func _ready():
	target = get_node("/root/Node3D/Player")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_level = clamp(zoom_level - zoom_speed, zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level = clamp(zoom_level + zoom_speed, zoom_min, zoom_max)

func _process(delta):
	if target:
		current_zoom = lerp(current_zoom, zoom_level, zoom_smooth * delta)
		position = target.global_position + Vector3(-current_zoom, current_zoom, -current_zoom)
		look_at(target.global_position, Vector3.UP)
