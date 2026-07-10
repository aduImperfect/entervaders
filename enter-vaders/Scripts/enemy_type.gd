extends Node2D

@export var enemyChildren : Array[Node] = []

@export var flipped : Array[bool] = []

@export var flipAccumulation : float = 0.0
@export var flipMax : float = 4.0

@export var speed : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemyChildren = get_children()
	_set_flips()
	_set_enemy_types()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#flipAccumulation += _delta * speed
	#if flipAccumulation > flipMax:
		#flipAccumulation = 0.0
		#_animate_flip()
	pass

func _set_enemy_types() -> void:
	for k in enemyChildren.size():
		var enemySprite : Sprite2D = enemyChildren[k].get_child(0).get_child(1) as Sprite2D
		if (k < 10):
			enemySprite.frame = 4
		elif (k < 30):
			enemySprite.frame = 2
		else:
			enemySprite.frame = 0

func _set_flips() -> void:
	for k in enemyChildren.size():
		flipped.append(false)

func _animate_flip() -> void:
	for k in enemyChildren.size():
		var enemyChild : Node = enemyChildren[k]

		if enemyChild:
			print(enemyChild)
			var _enemySprite : Sprite2D = enemyChild.get_child(0).get_child(1) as Sprite2D
			if flipped[k]:
				if (_enemySprite.frame % 2) != 0:
					_enemySprite.frame -= 1
				flipped[k] = false
			else:
				if (_enemySprite.frame % 2) == 0:
					_enemySprite.frame += 1
				flipped[k] = true
