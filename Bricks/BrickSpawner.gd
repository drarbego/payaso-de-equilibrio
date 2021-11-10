extends Node2D


const Brick = preload("res://Bricks/Brick.tscn")
export var AGGRESIVE_CHANCE = 0.33
export var MAX_HEALTH = 3

func _ready():
	self.spawn_bricks_row()

func spawn_bricks_row():
	var brick_width = Brick.instance().get_width()
	var brick_count = int(floor($Start.position.distance_to($End.position) / brick_width))

	for i in range(brick_count):
		var brick_pos_x = brick_width * i + brick_width/2
		var is_aggresive = randf() <= AGGRESIVE_CHANCE
		var health = (randi() % MAX_HEALTH) + 1

		var brick = Brick.instance().init(Vector2(brick_pos_x, 0), is_aggresive, health)
		add_child(brick)

func _on_SpawnTimer_timeout():
	get_tree().call_group("bricks", "move_to_next_row")
	$Tween.interpolate_callback(
		self,
		Brick.instance().get_time_until_next_pos(),
		"spawn_bricks_row"
	)
	$Tween.start()
