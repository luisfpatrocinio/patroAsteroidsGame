extends Node2D
class_name Level

@onready var camera_2d: Camera2D = $Camera2D

const PLAYER = preload("res://Scenes/player.tscn")
@onready var player: CharacterBody2D = null

const ASTEROID = preload("res://Scenes/asteroid.tscn");
@onready var asteroids: Node2D = $Asteroids
var MAX_ASTEROIDS: int = 3;

var lives : int = 0;
var score : int = 0;
var enemiesDestroyed : int = 0;

var gameStarted: bool = false;

## Ao inicializar o jogo.
func _ready() -> void:
	Interface.level = self;

## Core Loop e lógica do level
func _process(delta: float) -> void:
	Interface.lives_label.text = "Vidas: " + str(lives);
	Interface.score_label.text = "Pontos: " + str(score);
	manageBackground();
	manageCamera();
	
## Manipular background 
func manageBackground():
	for layer : Parallax2D in $Background.get_children():
		layer.autoscroll.x = 20 * (1 - int(gameStarted));
		
## Manipular câmera
func manageCamera():
	# Encerra a função caso não exista o player
	if !is_instance_valid(player): return;
	
	# Mover suavemente a câmera na posição do Player
	var screen_size = get_viewport_rect().size;
	var _limit = 3;
	var _newCamPosition = player.position.clamp(
		Vector2(screen_size.x / _limit, screen_size.y / _limit), 
		Vector2(screen_size.x * (_limit - 1) / _limit, screen_size.y * (_limit - 1) / _limit)
	);
	var _sp = camera_2d.position.distance_to(_newCamPosition) / 10.0;
	camera_2d.position = camera_2d.position.move_toward(_newCamPosition, _sp);

func spawnAsteroid() -> void:
	var _asteroid = ASTEROID.instantiate()
	
	# Obtem o tamanho da tela
	var screen_size = get_viewport_rect().size
	
	# Gera um número aleatório entre 0 e 1 para decidir onde spawnar o asteroide
	var edge = randi() % 4  # Existem 4 lados possíveis: topo, direita, baixo, esquerda
	
	var _pos = Vector2()
	
	# Dependendo do valor de 'edge', posicionamos o asteroide em um dos lados da tela
	match edge:
		0:  # Topo
			_pos.x = randf_range(0, screen_size.x)  # Posição X aleatória
			_pos.y = -10  # Fora da tela, um pouco acima
		1:  # Direita
			_pos.x = screen_size.x + 10  # Fora da tela, à direita
			_pos.y = randf_range(0, screen_size.y)  # Posição Y aleatória
		2:  # Fundo
			_pos.x = randf_range(0, screen_size.x)  # Posição X aleatória
			_pos.y = screen_size.y + 10  # Fora da tela, um pouco abaixo
		3:  # Esquerda
			_pos.x = -10  # Fora da tela, à esquerda
			_pos.y = randf_range(0, screen_size.y)  # Posição Y aleatória
	
	# Atribui a posição ao asteroide
	_asteroid.position = _pos
	
	# Adiciona o asteroide como filho da cena
	asteroids.add_child(_asteroid)


func _on_meteor_spawn_timer_timeout() -> void:
	if gameStarted and asteroids.get_child_count() < MAX_ASTEROIDS:
		spawnAsteroid();
		
func startGame():
	spawnPlayer();
	gameStarted = true;
	print("Jogo iniciado.");

func managePlayerDeath():
	if lives > 0:
		lives -= 1;
		await get_tree().create_timer(2.0).timeout;
		spawnPlayer();
	else:
		callGameOver();

func spawnPlayer():
	var _pl = PLAYER.instantiate();
	_pl.position = get_viewport_rect().size / 2.0 ;
	add_child(_pl);

func callGameOver():
	ConnectionManager.submitScore(self);
	Interface.game_over.visible = true;
