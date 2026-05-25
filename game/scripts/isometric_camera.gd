extends Camera3D

var target: Node3D

func _ready():
	position = Vector3(-15, 20, -15)
	look_at(Vector3.ZERO, Vector3.UP)
	target = get_node("/root/Node3D/Player")

func _process(_delta):
	if target:
		position = target.global_position + Vector3(-15, 20, -15)
		look_at(target.global_position, Vector3.UP)
