extends CharacterBody3D

@export var speed: float = 5.0
@export var target_path: NodePath  # arrastrás el nodo destino desde el Inspector

@onready var nav_agent = $NavigationAgent3D
var target: Node3D

func _ready():
	target = get_node(target_path)

func _physics_process(delta):
	if not target:
		return

	# decirle al agente a dónde ir
	nav_agent.target_position = target.global_position

	# moverse hacia el siguiente punto del camino
	var next_point = nav_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= 20.0 * delta  # gravedad

	move_and_slide()
