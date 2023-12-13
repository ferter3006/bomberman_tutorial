extends Node

signal bombs_value_changed(value : int)
signal score_changed(value : int)
signal key_changed(value : int)

var start_num_bombs : int = 5
var wood_box_points : int = 50
var enemy_kill_points : int = 250

var current_level : int = 0
var bombs : int = start_num_bombs : set = set_bombs
var keys : int = 0 : set = set_key
var score : int = 0 : set = set_score

var array_of_levels : Array[String] = [
	"res://Levels/Level1/Level1.tscn",
	"res://Levels/Level2/Level2.tscn"
]

func set_bombs(value):
	bombs = value
	emit_signal("bombs_value_changed", value)

func set_score(value):
	score = value
	emit_signal("score_changed", value)

func set_key(value):
	keys = value
	emit_signal("key_changed", value)
