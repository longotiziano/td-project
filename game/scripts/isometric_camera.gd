extends Camera3D

var target: Node3D

func _ready():
	await get_tree().process_frame
	target = get_node("../Player")
	if target:
		print("✅ Cámara encontró al Player!")
	else:
		print("⚠️ No encontró al Player!")

func _process(_delta):
	if target:
		position = target.global_position + Vector3(-15, 20, -15)
		look_at(target.global_position, Vector3.UP)
