class_name ScoreCalculator

static var player_score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func _reset_player_score() -> void:
	player_score = 0

static func _add_to_player_score(_addVal : int) -> void:
	player_score += _addVal
