extends Node

const LEVEL_SCENE = preload("res://Scenes/level.tscn")
@export var levelNode : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _load_level() -> void:
	var level_instance = LEVEL_SCENE.instantiate()
	level_instance.global_position.x = 0.0
	level_instance.global_position.y = 0.0
	add_child(level_instance)
	levelNode = level_instance
