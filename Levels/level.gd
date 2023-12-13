extends Node2D
class_name LevelClass

@onready var box_count : int = $WoodBoxes.get_child_count()
@onready var player : Player = get_tree().get_first_node_in_group("player")
var collectable_bomb : PackedScene = preload("res://CollectableItems/collectable_bomb.tscn")
var collectable_key : PackedScene = preload("res://CollectableItems/collectable_key.tscn")
var portal : PackedScene = preload("res://Portal/portal.tscn")
var lose_escene : PackedScene = preload("res://MainScene/you_lose.tscn")
var key_popped : bool = false
var portal_popped : bool = false


func _ready():
	randomize()
	player.portal_reached.connect(end_of_game_win)
	player.player_die.connect(end_of_game_lose)

func end_of_game_win():
	GameStats.current_level += 1
	if GameStats.current_level < GameStats.array_of_levels.size():
		get_tree().change_scene_to_file(GameStats.array_of_levels[GameStats.current_level])
	else:
		get_tree().change_scene_to_file("res://MainScene/you_win.tscn")

func end_of_game_lose():
	var new_lose = lose_escene.instantiate()
	get_tree().paused = true
	add_child(new_lose)
