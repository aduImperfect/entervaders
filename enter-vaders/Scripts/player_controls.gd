extends RigidBody2D

@export var offset : float = 200.0

@export var ray2D : RayCast2D
#@export var bulletRect : Rect2
#@export var bulletDraw : bool

@export var ray_origin : Vector2
@export var ray_target : Vector2

#@export var hit_position = Vector2.ZERO
#@export var is_hitting = false

@export var bullet_on : bool = false

@export var ray_stay_limit : float  = 0.05
@export var ray_stay_accumulation : float  = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerMgr._reset_player_info()
	#The 3rdchild is a ray cast 2D node!
	ray2D = get_child(2)
	#bulletDraw = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if PlayerMgr.player_dead:
		return

	if bullet_on:
		ray_stay_accumulation += _delta
		if ray_stay_accumulation > ray_stay_limit:
			ray_stay_accumulation = 0.0
			bullet_on = false
			ray2D.position = Vector2(0.0, 0.0)
			ray2D.target_position = Vector2(0.0, 0.0)
			ray2D.enabled = false

	if Input.is_action_pressed("ui_player_left"):
		if position.x > 0.0:
			position.x -= _delta * offset
		else:
			position.x = 0.0

	if Input.is_action_pressed("ui_player_right"):
		if position.x < 950.0:
			position.x += _delta * offset
		else:
			position.x = 950.0

func _physics_process(_delta: float) -> void:
	if PlayerMgr.player_dead:
		return

	if Input.is_action_just_pressed("ui_player_bullet"):
		#print("Bullet Ray!")
		perform_node_raycast()
		#perform_immediate_raycast()

func _input(_event: InputEvent) -> void:
	pass

func perform_node_raycast() -> void:
	ray2D.enabled = true
	ray2D.collide_with_areas = true
	ray2D.collide_with_bodies = true
	# Layers 3, 4, and 5
	ray2D.collision_mask = (1 << 2) | (1 << 3) | (1 << 4)
	ray2D.position = Vector2(0.0, 0.0)
	ray2D.target_position = Vector2(0.0, -1000.0)
	#print("Ray2D positions: Origin, Target: ", ray2D.position, ", ", ray2D.target_position)
	bullet_on = true

	var first_collided_obj : Node2D = ray2D.get_collider()

	if first_collided_obj:
		#print("Ray collided with object: ", first_collided_obj)
		var collisionOwner : Node2D = first_collided_obj.owner
		if first_collided_obj.name.contains("Enemy"):
			if collisionOwner.get_index() < 10:
				ScoreCalculator._add_to_player_score(30)
			elif collisionOwner.get_index() < 30:
				ScoreCalculator._add_to_player_score(20)
			else:
				ScoreCalculator._add_to_player_score(10)
		
		collisionOwner.remove_child(first_collided_obj)

#func perform_immediate_raycast() -> void:
	## 1. Get the direct physics space state
	#var space_state = get_world_2d().direct_space_state
	#
	## 2. Define origin and destination coordinates (Global positions)
	#ray_origin = Vector2(0.0, 0.0)
	#ray_target = Vector2(0.0, -1000.0)
#
	#print("Origin: " + str(ray_origin) + " and End: " + str(ray_target))
#
	## 3. Set up the query parameters
	#var query = PhysicsRayQueryParameters2D.create(ray_origin, ray_target)
	#query.collide_with_areas = true
	#query.collide_with_bodies = true
	## Layers 3, 4, and 5
	#query.collision_mask = (1 << 2) | (1 << 3) | (1 << 4)
	#query.exclude = [self] # Prevent the raycast from hitting yourself
#
#
	## 4. Execute the query
	#var result = space_state.intersect_ray(query)
	#print(result)
	#
	## 5. Check if the dictionary contains data
	#if result:
		#print("Hit target at global position: ", result.position)
		#print("Hit object reference: ", result.collider)
		#is_hitting = true
		#hit_position = result.position
	#else:
		#is_hitting = false
#
	#queue_redraw()
#
#func _draw():
	## Draw the base ray path
	#draw_line(ray_origin, ray_target, Color.GREEN, 2.0)
	#
	## If there is a collision, draw a red circle at the hit point
	#if is_hitting:
		#draw_circle(hit_position, 8.0, Color.RED)
