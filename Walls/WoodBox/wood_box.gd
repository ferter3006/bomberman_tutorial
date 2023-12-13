extends StaticBody2D

@onready var animation : AnimationPlayer = $AnimationPlayer

@onready var level : LevelClass = get_tree().get_first_node_in_group("level")

func _on_area_2d_area_entered(area):
	if area.is_in_group("bomb"):
		GameStats.score += GameStats.wood_box_points
		animation.play("destroy")
		level.box_count -= 1
		call_deferred("spawn_items")

func spawn_items():
	var key_prob : float = 100.0 / level.box_count
	var rnum : float = randf_range(0,100)
	if rnum < key_prob:
		print("Pongo key por que salió un ", rnum, " i es mas pequeño que ", key_prob)
		pop_key()
	else:
		pop_dyn()

func pop_dyn():
	var num : int = randi_range(1,10)
	if num < 6:
		put_item(level.collectable_bomb)

func pop_key():
	if !level.key_popped:
		level.key_popped = true
		put_item(level.collectable_key)
	else:
		if !level.portal_popped:
			level.portal_popped = true
			put_item(level.portal)

func put_item(item : PackedScene):
	var new_item = item.instantiate()
	new_item.position = position
	level.add_child(new_item)
	
