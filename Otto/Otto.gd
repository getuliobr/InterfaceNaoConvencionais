extends CharacterBody2D


const SPEED = 100
const ROTATE_SPEED = 1.5
var facing: float = 0.0

@onready var screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Andar para frente e para tras
	var towards := Input.get_axis("ui_up", "ui_down")
	velocity = transform.y * towards * SPEED
	# Rotacionar no proprio eixo
	var rotateDir := Input.get_axis("ui_left", "ui_right")
	rotation += ROTATE_SPEED * rotateDir * delta
	# Movimentar
	move_and_slide()
	# Fazer o "wrap" na tela, sair de um lado e aparecer do outro
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
	
func walk(delta: float) -> void:
	pass
