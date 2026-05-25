extends CharacterBody3D # tipo del script, en este caso "agrega a CharacterBody3D"

@export var speed  : float = 5.0
@export var run_speed   : float = 10.0  # velocidad corriendo
@export var gravity: float = 20.0

# movimiento con y = 0
var ISO_FORWARD = Vector3(-1, 0, -1).normalized()
var ISO_RIGHT   = Vector3(-1, 0,  1).normalized()

# "busca este nodo cuando la escena esté lista" -> $ es un atajo para get_node()
@onready var mesh = $MeshInstance3D

func _physics_process(delta):# se ejecuta a frecuencia fija, 60 veces por segundo siempre, sin importar los FPS
	if not is_on_floor():
		velocity.y -= gravity * delta

	var raw := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up",   "ui_down")
	)

	var current_speed = run_speed if Input.is_action_pressed("run") else speed

	if raw.length() > 0.1:
		print("Moviendo: ", raw)
		raw = raw.normalized()
		var dir = (ISO_RIGHT * raw.x + ISO_FORWARD * raw.y)
		velocity.x = dir.x * current_speed
		velocity.z = dir.z * current_speed

		var look_dir = Vector3(velocity.x, 0, velocity.z)
		if look_dir.length() > 0.01:
			mesh.rotation.y = lerp_angle(
				mesh.rotation.y,
				atan2(look_dir.x, look_dir.z),
				delta * 12.0
			)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
