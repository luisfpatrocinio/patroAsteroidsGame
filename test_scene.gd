extends CanvasLayer

@onready var name_text_edit: TextEdit = $Control/VBoxContainer/NameTextEdit;
@onready var score_text_edit: TextEdit = $Control/VBoxContainer/ScoreTextEdit;
@onready var send_button: Button = $Control/VBoxContainer/SendButton;

func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("http://localhost:3000/")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json.message)	

func _on_post_button_pressed() -> void:
	var _packet = {
		"name": name_text_edit.text,
		"score": score_text_edit.text
	};
	var body = JSON.new().stringify(_packet);
	
	$HTTPRequest.request("http://localhost:3000/score/", ["Content-Type: application/json"], HTTPClient.METHOD_POST, body);
	
	


func _on_get_button_pressed() -> void:
	$HTTPRequest.request("http://localhost:3000/")
