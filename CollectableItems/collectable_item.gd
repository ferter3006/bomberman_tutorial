extends Area2D
class_name ItemCollectable

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animation.play("bounce")
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area : Area2D):
	if area.is_in_group("player"):
		queue_free()
