extends CharacterBody3D

@export var speed = 2.5
@export var health = 3
@export var detection_range = 10.0

@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $AnimationPlayer

var player: Node3D = null
var is_dead = false

func _ready():
	# Buscá al jugador por grupo (necesitás agregar al Player al grupo "player")
	player = get_tree().get_first_node_in_group("player")

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if is_dead or player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance < detection_range:
		# Mover hacia el jugador con NavigationAgent
		nav_agent.target_position = player.global_position
		
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
		
		# Rotar hacia el jugador
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		
		anim_player.play("walk")  # si tenés animación
	else:
		velocity = Vector3.ZERO
		anim_player.play("idle")
	
	move_and_slide()

func take_damage(amount: int):
	if is_dead:
		return
	health -= amount
	if health <= 0:
		die()

func die():
	is_dead = true
	anim_player.play("death")
	# Esperar a que termine la animación y borrar el nodo
	await anim_player.animation_finished
	queue_free()
