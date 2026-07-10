extends RigidBody2D

@export var offset : float = 200.0

@export var ray2D : RayCast2D

@export var ray_origin : Vector2
@export var ray_target : Vector2

@export var bullet_on : bool = false

@export var ray_stay_limit : float = 0.2
@export var ray_stay_accumulation : float  = 0.0

@export var ray_fire_time : float = 4.0
@export var ray_fire_accumulation : float = 0.0

@export var move_speed : float = 0.0
@export var move_left : bool = true
@export var move_right : bool = false
@export var move_down : bool = false
@export var count : int = 0

@export var move_limit = 1.0
@export var move_accumulation = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#The 3rdchild is a ray cast 2D node!
	ray2D = get_child(2)
	move_speed = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if PlayerMgr.player_dead:
		return

	if position.y > 500.0:
		print("Vaders successfully invaded!")
		PlayerMgr._set_player_as_dead()

	if bullet_on:
		ray_stay_accumulation += _delta
		if ray_stay_accumulation > ray_stay_limit:
			ray_stay_accumulation = 0.0
			bullet_on = false
			ray2D.position = Vector2(0.0, 0.0)
			ray2D.target_position = Vector2(0.0, 0.0)
			ray2D.enabled = false

	move_accumulation += _delta
	if move_accumulation > move_limit:
		move_accumulation = 0.0
		if move_left:
			if position.x < 150.0:
				position.x += _delta * offset * move_speed
			else:
				#position.x = 120.0
				move_left = false
				move_right = false
				move_down = true
				count += 1
		elif move_right:
			if position.x > 0.0:
				position.x -= _delta * offset * move_speed
			else:
				position.x = 0.0
				move_down = true
				move_left = false
				move_right = false
				count += 1
		elif move_down:
			position.y += _delta * offset * move_speed
			if (count % 2) == 0:
				move_left = true
			else:
				move_right = true
			move_down = false


func _physics_process(_delta: float) -> void:
	if PlayerMgr.player_dead:
		return

	#ray_fire_accumulation += _delta
	#if ray_fire_accumulation > ray_fire_time:
		#ray_fire_accumulation = 0.0
	var shootBullet : float = randf_range(0.0, 10000.0)
	if shootBullet < 30.0:
		#print("Bullet Ray!")
		perform_node_raycast()

func _input(_event: InputEvent) -> void:
	pass

func perform_node_raycast() -> void:
	ray2D.enabled = true
	ray2D.collide_with_areas = true
	ray2D.collide_with_bodies = true
	# Layers 1, 2, and 5
	ray2D.collision_mask = (1 << 0) | (1 << 1) | (1 << 4)
	ray2D.position = Vector2(0.0, 0.0)
	ray2D.target_position = Vector2(0.0, 1000.0)
	#print("Ray2D positions: Origin, Target: ", ray2D.position, ", ", ray2D.target_position)
	bullet_on = true

	var first_collided_obj : Node2D = ray2D.get_collider()

	if first_collided_obj:
		#print("Ray collided with object: ", first_collided_obj)
		if first_collided_obj.name.contains("Player"):
			print("Player Hit!! ", first_collided_obj.name)
			PlayerMgr._set_player_as_dead()
		else:
			var collisionOwner : Node2D = first_collided_obj.owner
			if collisionOwner:
				collisionOwner.remove_child(first_collided_obj)
