extends Entity
class_name Player

@onready var trail_sprite: Sprite2D = $TrailEffect
const PROJECTILE = preload("res://Scenes/projectile.tscn")

# Variáveis de controle
var acceleration = 200  # Aceleração quando o player se move
var max_speed = 300      # Velocidade máxima
var friction = 50        # Fricção que reduz a velocidade gradualmente
var rotation_speed = 2.5  # Velocidade de rotação
var impulsing : bool = true;

var shoot_interval: float = 0.30;
var time_since_last_shot : float = 0.0;

func _ready() -> void:
	get_parent().player = self;

func _physics_process(delta):
	# Controle de rotação
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += rotation_speed
	
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= rotation_speed

	# Controle de aceleração para frente
	impulsing = Input.is_action_pressed("ui_up");
	if impulsing:
		# Acelera na direção em que o player está apontando
		var direction = Vector2(cos(rotation), sin(rotation));
		velocity += direction * acceleration * delta;
	
	# Controle de tiros
	time_since_last_shot += delta	
	if Input.is_action_pressed("shoot") and time_since_last_shot >= shoot_interval:
		shoot()
		time_since_last_shot = 0.0
	
	# Aplicando fricção para desacelerar
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# Limitar a velocidade máxima
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	# Gerenciar efeito de rastro
	handle_trail_effect();
	
	# Movimento do player
	move_and_slide();

	# Se sair da tela, teleporta para o lado oposto (efeito wrap-around)
	handle_screen_wrap();



## Função para controlar a intensidade do rastro
func handle_trail_effect():
	var _newTrailAlpha = velocity.length() / max_speed * int(impulsing);
	trail_sprite.modulate.a = move_toward(trail_sprite.modulate.a, _newTrailAlpha, 0.069);


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		takeDamage();
		
func takeDamage():
	die();
	
func die():
	queue_free();
	var _level = get_parent() as Level;
	_level.managePlayerDeath();

# Função para disparar o projétil
func shoot():
	# Instancia o projétil
	var projectile = PROJECTILE.instantiate()
	# Define a posição e rotação do projétil igual à do player
	projectile.position = position
	projectile.rotation = rotation
	# Define a direção do projétil com base na rotação do player
	projectile.direction = Vector2(cos(rotation), sin(rotation)).normalized()
	# Adiciona o projétil à cena
	get_parent().add_child(projectile)
