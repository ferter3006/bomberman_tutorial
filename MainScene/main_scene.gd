extends Node2D

@onready var master : HSlider = $AudioSliders/Master
@onready var music : HSlider = $AudioSliders/Music
@onready var effects : HSlider = $AudioSliders/Effects

func _ready():
	get_volums()
	GameStats.current_level = 0
	GameStats.score = 0
	GameStats.bombs = GameStats.start_num_bombs

func _on_start_game_pressed():
	Audios.click.play()
	var i : int = GameStats.current_level
	get_tree().change_scene_to_file(GameStats.array_of_levels[i])

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)

func _on_effects_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)

func get_volums():
	master.value = AudioServer.get_bus_volume_db(0)
	music.value = AudioServer.get_bus_volume_db(1)
	effects.value = AudioServer.get_bus_volume_db(2)
