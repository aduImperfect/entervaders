class_name PlayerMgr

static var player_dead : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func _reset_player_info() -> void:
	player_dead = false

static func _set_player_as_dead() -> void:
	player_dead = true
