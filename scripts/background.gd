extends Node2D
@onready var furthest: Parallax2D = $Furthest;
@onready var far: Parallax2D = $Far;
@onready var close: Parallax2D = $Close;
@onready var closest: Parallax2D = $Closest;

@export var starsPerLayer: int = 8;

var texturesDict: Dictionary = {
	"tiny": preload("res://Retina/star_tiny.png"),
	"small": preload("res://Retina/star_small.png"),
	"medium": preload("res://Retina/star_medium.png"),
	"large": preload("res://Retina/star_large.png")
}

func _ready() -> void:
	var _layers = [furthest, far, close, closest];
	for n in range(len(_layers)):
		var _layer = _layers[n] as Parallax2D;
		var _scrollScale = 0.169 + n * 0.169;
		_layer.scroll_scale =  Vector2(_scrollScale, _scrollScale)
		var _textureKey = texturesDict.keys()[n]
		for i in range(starsPerLayer):
			var _sprite = Sprite2D.new();
			_sprite.texture = texturesDict.get(_textureKey);
			_sprite.position = Vector2(randf_range(0, 960), randf_range(0, 540));
			var _scale = 0.10 + n * 0.069;
			_sprite.scale = Vector2(_scale, _scale);
			_layer.add_child(_sprite);
