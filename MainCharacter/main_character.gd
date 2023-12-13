extends Area2D
class_name Player

signal portal_reached
signal player_die

@onready var level : LevelClass = get_tree().get_first_node_in_group("level")
@onready var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_up : RayCast2D = $RayCasts/Up
@onready var ray_down : RayCast2D = $RayCasts/Down
@onready var ray_left : RayCast2D = $RayCasts/Left
@onready var ray_right : RayCast2D = $RayCasts/Right

var bomb : PackedScene = preload("res://Bomb/bomb.tscn")

const PIXELS : int = 32
var tween : Tween
var moving : bool = true
var current_idle = "idle_down"
var death : bool = false
@onready var valid_position = position

func _ready():
	pass

func _process(_delta):
	if death: return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction && !moving:
		move_me(direction)
	if !direction && !moving:
		animations.play(current_idle)

func _input(event):
	if event.is_action_pressed("place_bomb"):
		place_bomb()

func place_bomb():
	if GameStats.bombs > 0:
		GameStats.bombs -= 1
		var newbomb = bomb.instantiate()
		newbomb.position = valid_position
		add_sibling(newbomb)

func move_me(direction):
	
	var next_position : Vector2
	
	if direction.x < 0 && !ray_left.is_colliding(): #left
		next_position = position + Vector2(-PIXELS, 0)
		animations.play("walk_left")
		current_idle = "idle_left"
		move_by_tween(next_position)
		
	elif direction.x > 0 && !ray_right.is_colliding(): #right
		next_position = position + Vector2(PIXELS, 0)
		animations.play("walk_right")
		current_idle = "idle_right"
		move_by_tween(next_position)
		
	elif direction.y < 0 && !ray_up.is_colliding(): #up
		next_position = position + Vector2(0, -PIXELS)
		animations.play("walk_up")
		current_idle = "idle_up"
		move_by_tween(next_position)
		
	elif direction.y > 0 && !ray_down.is_colliding(): #down
		next_position = position + Vector2(0, PIXELS)
		animations.play("walk_down")
		current_idle = "idle_down"
		move_by_tween(next_position)
	else:
		animations.play(current_idle)

func move_by_tween(next_position : Vector2):
	moving = true
	valid_position = next_position
	tween = create_tween()
	tween.tween_property(self, "position", next_position, 0.2)
	tween.tween_callback(end_of_tween)

func end_of_tween():
	moving = false

func _on_area_entered(area : Area2D):
	if area.is_in_group("bomb") || area.is_in_group("enemy"):
		emit_signal("player_die")
		animations.play("die")
		death = true
	elif area.is_in_group("collectable_key"):
		GameStats.keys += 1
	elif area.is_in_group("collectable_bomb"):
		GameStats.bombs += 1
	elif area.is_in_group("portal"):
		if GameStats.keys > 0:
			emit_signal("portal_reached")
			GameStats.keys -= 1


func _on_ready_timer_timeout():
	moving = false
