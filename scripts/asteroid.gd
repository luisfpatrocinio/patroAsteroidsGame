extends Area2D
class_name Asteroid

var minSpeed = 0.69;
var maxSpeed = 1.69;
var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized();
var velocity = direction * randf_range(minSpeed, maxSpeed);
var canHit = false;
@onready var sprite_2d: Sprite2D = $Sprite2D;

func _ready() -> void:
	sprite_2d.modulate = Color.TRANSPARENT;
	
	var _tween = get_tree().create_tween();
	_tween.tween_property(sprite_2d, "modulate", Color.WHITE, 1.0);
	await _tween.finished;
	
	canHit = true;
	
func _physics_process(delta: float) -> void:
	sprite_2d.rotation_degrees += velocity.x / 1.69;
	position += velocity;
	handle_screen_wrap();

## Função para fazer o wrap-around quando o asteróide sai da tela
func handle_screen_wrap():
	var screen_size = get_viewport_rect().size
	var margin = 64  # Define uma margem para o wrap-around

	if position.x > screen_size.x + margin:
		position.x = -margin  # Move o asteroide para fora do lado oposto
	elif position.x < -margin:
		position.x = screen_size.x + margin  # Move o asteroide para fora do lado oposto

	if position.y > screen_size.y + margin:
		position.y = -margin
	elif position.y < -margin:
		position.y = screen_size.y + margin


func takeDamage():
	var _level = get_parent().get_parent() as Level;
	_level.score += 100;
	_level.enemiesDestroyed += 1;
	queue_free();
