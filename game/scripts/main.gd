extends Node3D

func _ready():
	# Agrandar la ventana manteniendo la resolución PS2
	DisplayServer.window_set_size(Vector2i(1152, 648))
	
	var container = $SubViewportContainer
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
