extends CharacterBody3D # tipo del script, en este caso "agrega a CharacterBody3D"

@export var speed  : float = 5.0
@export var gravity: float = 20.0

var ISO_FORWARD = Vector3(-1, 0, -1).normalized()
var ISO_RIGHT   = Vector3(-1, 0,  1).normalized()

@onready var mesh = $MeshInstance3D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var raw := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up",   "ui_down")
	)

	if raw.length() > 0.1:
		print("Moviendo: ", raw)
		raw = raw.normalized()
		var dir = (ISO_RIGHT * raw.x + ISO_FORWARD * raw.y)
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed

		var look_dir = Vector3(velocity.x, 0, velocity.z)
		if look_dir.length() > 0.01:
			mesh.rotation.y = lerp_angle(
				mesh.rotation.y,
				atan2(look_dir.x, look_dir.z),
				delta * 12.0
			)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
