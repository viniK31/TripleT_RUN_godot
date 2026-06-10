extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@export var VELOCIDADE_SUBIDA = 200.0 # Velocidade para subir/descer a escada

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var na_escada: bool = false # Controla se o player está na área da escada

func _physics_process(delta: float) -> void:
	# 1. GERENCIAMENTO DA GRAVIDADE
	if na_escada:
		# Se estiver na escada, neutraliza a queda acumulada para não travar o boneco
		velocity.y = 0 
	elif not is_on_floor():
		# Aplica gravidade normal se estiver no ar e fora da escada
		velocity += get_gravity() * delta
		
	# 2. SISTEMA DE PULO
	# Permite pular se estiver no chão OU pular para se soltar da corda no ar
	if Input.is_action_just_pressed("jump") and (is_on_floor() or na_escada):
		velocity.y = JUMP_VELOCITY
		if na_escada:
			na_escada = false # Se pulou na corda, força ele a soltar e cair/subir

	# 3. CONTROLES DE MOVIMENTO (Esquerda / Direita)
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# 4. CONTROLES DA ESCADA (Garantido para Setas e WASD)
	if na_escada:
		var input_vertical := 0.0
		
		# Verifica diretamente as teclas físicas (W/S ou Setas Cima/Baixo)
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			input_vertical = -1.0 # Sobe (Y negativo)
		elif Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
			input_vertical = 1.0  # Desce (Y positivo)
			
		velocity.y = input_vertical * VELOCIDADE_SUBIDA

	# 5. GERENCIAMENTO DE ANIMAÇÕES
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Condições de animação incluindo a escada
	if na_escada and velocity.y != 0:
		animated_sprite_2d.play("walk") 
	elif is_on_floor():	
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
	else:
		if not na_escada:
			animated_sprite_2d.play("jump")

	move_and_slide()

# 6. FUNÇÕES PARA A ESCADA ATIVAR
func entra_na_escada() -> void:
	na_escada = true

func sai_da_escada() -> void:
	na_escada = false
	velocity.y = 0 # Evita que ele caia rápido demais ao sair
