extends CanvasLayer
@onready var login: Control = $Login
@onready var connecting_message: Label = $ConnectingMessage
@onready var level : Level = null;
@onready var game_over: Control = $GameOver

@onready var player_name: LineEdit = $Login/VBoxContainer/PlayerName
@onready var play_button: Button = $Login/VBoxContainer/PlayButton

@onready var bottom_bar: Control = $BottomBar
@onready var lives_label: Label = $BottomBar/LivesLabel
@onready var score_label: Label = $BottomBar/ScoreLabel
@onready var high_score_label: Label = $BottomBar/HighScoreLabel


func _ready() -> void:
	lives_label.visible = false;
	score_label.visible = false;
	game_over.visible = false;

func _process(delta: float) -> void:
	connecting_message.text = "Conectado!" if ConnectionManager.connected else "Conectando...";
	
	if !level.gameStarted:
		login.visible = ConnectionManager.connected;
		connecting_message.visible = !ConnectionManager.connected;
		
		play_button.disabled = player_name.text.is_empty()
		
		if login.visible:
			focusTextBox();
			if Input.is_action_just_pressed("ui_accept"):
				play_button.emit_signal("pressed")

func _on_play_button_pressed() -> void:
	level.startGame();
	connecting_message.visible = false;
	login.visible = false;
	ConnectionManager.playerName = player_name.text;
	lives_label.visible = true;
	score_label.visible = true;
	ConnectionManager.getPlayerData()
	
func focusTextBox():
	player_name.grab_focus();
	
func getPatentNameByRank(rank: int) -> String:
	var ranks = [
		"Cadete",          # Rank 0
		"Tenente",         # Rank 1
		"Capitão",         # Rank 2
		"Major",           # Rank 3
		"Coronel",         # Rank 4
		"Brigadeiro",      # Rank 5
		"General",         # Rank 6
		"Marechal",        # Rank 7
		"Comandante Supremo", # Rank 8
		"Almirante Grande" # Rank 9
		]
	
	if rank >= 0 and rank < ranks.size():
		return ranks[rank]
	else:
		return "Classificação Desconhecida"  # Caso a classificação não esteja dentro do intervalo esperado

	
func updateBottomBar(data: Dictionary):
	var playerName = bottom_bar.get_node("PlayerName") as Label;
	playerName.text = data.get("name") + " - " + getPatentNameByRank(data.get("rankLevel"));
	high_score_label.text = "Highscore: %s" % data.get("highestScore");
	
