extends Node2D

@onready var click : AudioStreamPlayer = $Click
@onready var bomb : AudioStreamPlayer = $Bomb

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_click():
	click.play()

func play_bomb():
	bomb.play()
