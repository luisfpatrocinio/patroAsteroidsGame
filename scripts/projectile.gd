extends Area2D

var speed = 500  # Velocidade do projétil
var direction = Vector2.ZERO  # Direção na qual o projétil será disparado

func _ready():
	# Conecta o sinal de colisão ao método que destrói o projétil
	connect("area_entered", _on_Projectile_area_entered)

func _physics_process(delta):
	# Move o projétil na direção especificada
	position += direction * speed * delta
	
	# Remove o projétil se ele sair da tela
	if is_out_of_bounds():
		queue_free()

# Função chamada quando o projétil colide com outra área
func _on_Projectile_area_entered(area):
	if area is Player:
		pass
	
	if area is Asteroid:
		area.takeDamage();
		queue_free();

# Verifica se o projétil está fora dos limites da tela
func is_out_of_bounds() -> bool:
	var screen_size = get_viewport_rect().size
	var margin = 50  # Define uma margem para os limites da tela
	return position.x < -margin or position.x > screen_size.x + margin or position.y < -margin or position.y > screen_size.y + margin
