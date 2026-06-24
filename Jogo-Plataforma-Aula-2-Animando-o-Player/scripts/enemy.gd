extends CharacterBody2D

const SPEED = 80.0
const GRAVITY = 800.0

var direction = 1
var can_turn = true # Nova variável para controlar o tempo de virada

@onready var floor_left: RayCast2D = %FloorLeft
@onready var floor_right: RayCast2D = %FloorRight
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Aplica a gravidade continuamente
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Só tenta virar se o temporizador permitir (evita o bug de tremer)
	if can_turn:
		var changed_direction = false
		
		# Inverte a direção se detectar buracos
		if not floor_left.is_colliding() and direction == -1:
			direction = 1
			changed_direction = true
		elif not floor_right.is_colliding() and direction == 1:
			direction = -1
			changed_direction = true
			
		# Inverte a direção se bater em uma parede
		if is_on_wall() and not changed_direction:
			direction = -direction
			changed_direction = true
			
		# Se ele mudou de direção, ativa o bloqueio temporário
		if changed_direction:
			trigger_turn_cooldown()

	# Aplica velocidade no eixo X
	velocity.x = direction * SPEED
	
	# Espelha o sprite e roda a animação
	anim.flip_h = direction > 0
	anim.play("walk")

	# Move o personagem
	move_and_slide()

# Função que cria um cronômetro rápido de 0.2 segundos antes de deixar virar de novo
func trigger_turn_cooldown():
	can_turn = false
	await get_tree().create_timer(0.2).timeout
	can_turn = true
