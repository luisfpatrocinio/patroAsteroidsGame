extends HTTPRequest

var headers = ["Content-Type: application/json"];
var connected : bool = false;
var playerName : String = "";

func _ready() -> void:
	request("http://localhost:3000/", headers, HTTPClient.METHOD_GET);

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if json == null:
		print("JSON não deu certo.")
		return;
	
	connected = true;
	
	# Analisar tipo de pacote recebido:
	match json["type"]:
		"connected":
			print("Seja bem vindo.");
		"playerData":
			Interface.updateBottomBar(json["content"])
			
		"scoreReceived":
			print("Pontuação submetida.");
	
	
	
func submitScore(levelRef: Level):
	var _packet = {
		"name": playerName,
		"score": levelRef.score,
		"enemiesDestroyed": levelRef.enemiesDestroyed,
		"timeStamp": Time.get_datetime_dict_from_system()
	};
	var body = JSON.new().stringify(_packet);
	request("http://localhost:3000/score/", headers, HTTPClient.METHOD_POST, body);

func getPlayerData():
	print("Obtendo dados do jogador: " + playerName);
	request("http://localhost:3000/player/" + playerName, headers, HTTPClient.METHOD_GET);
