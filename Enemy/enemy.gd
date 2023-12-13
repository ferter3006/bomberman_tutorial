extends Area2D

@onready var ray_up : RayCast2D = $RayCasts/Up
@onready var ray_down : RayCast2D = $RayCasts/Down
@onready var ray_left : RayCast2D = $RayCasts/Left
@onready var ray_right : RayCast2D = $RayCasts/Right

@onready var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready var level : LevelClass = get_tree().get_first_node_in_group("level")

const PIXELS = 32
var moving : bool = true
var tween : Tween
var actual_direction : Callable = move_up
var array_moves : Array[Callable]
@onready var valid_position : Vector2 = position

func _ready():
	pass

func _process(_delta):
	if !moving:
		if need_to_change():
			find_directions()
			array_moves.shuffle()
			if array_moves.size() > 0:
				array_moves[0].call()
				actual_direction = array_moves[0]
		else:
			actual_direction.call()

func need_to_change():
	if actual_direction == move_up:
		return ray_up.is_colliding()
	elif actual_direction == move_down:
		return ray_down.is_colliding()
	elif actual_direction == move_left:
		return ray_left.is_colliding()
	elif actual_direction == move_right:
		return ray_right.is_colliding()

func find_directions():
	array_moves = []
	
	if !ray_up.is_colliding():
		array_moves.append(move_up)
	if !ray_down.is_colliding():
		array_moves.append(move_down)
	if !ray_left.is_colliding():
		array_moves.append(move_left)
	if !ray_right.is_colliding():
		array_moves.append(move_right)
	
	return array_moves

func move_up():
	animations.play("up")
	move_by_tween(valid_position + (Vector2.UP * PIXELS))

func move_down():
	animations.play("down")
	move_by_tween(valid_position + (Vector2.DOWN * PIXELS))

func move_left():
	animations.play("left")
	move_by_tween(valid_position + (Vector2.LEFT * PIXELS))

func move_right():
	animations.play("right")
	move_by_tween(valid_position + (Vector2.RIGHT * PIXELS))

func move_by_tween(next_position : Vector2):
	moving = true
	valid_position = next_position
	tween = create_tween()
	tween.tween_property(self, "position", next_position, 0.5)
	tween.tween_callback(end_of_tween)

func end_of_tween():
	moving = false

func _on_ready_timer_timeout():
	moving = false

func _on_area_entered(area : Area2D):
	if area.is_in_group("bomb"):
		call_deferred("pop_bomb", position)
		GameStats.score += GameStats.enemy_kill_points
		queue_free()
		
func pop_bomb(my_position):
	var new_bomb = level.collectable_bomb.instantiate()
	new_bomb.position = my_position
	level.add_child(new_bomb)
