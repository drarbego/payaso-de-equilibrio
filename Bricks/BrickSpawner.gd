extends Node2D


const Brick = preload("res://Bricks/Brick.tscn")
export var MAX_HEALTH = 3
onready var BRICK_WIDTH = Brick.instance().get_width()
onready var BRICK_COUNT = int(floor($Start.position.distance_to($End.position) / BRICK_WIDTH))

func _ready():
	self.spawn_bricks_row()

func spawn_bricks_row():
	for i in range(self.BRICK_COUNT):
		var brick_pos_x = BRICK_WIDTH * i + BRICK_WIDTH/2
		var brick = self.build_brick(brick_pos_x)
		brick.connect("destroyed", get_parent(), "add_score")
		add_child(brick)

func build_brick(pos):
	var is_aggresive = randf() <= Globals.AGGRESIVE_CHANCE
	var health = (randi() % Globals.BRICK_HEALTH) + 1

	return Brick.instance().init(
		Vector2(pos, 0),
		is_aggresive,
		health,
		Globals.MIN_SPAWN_TIME,
		Globals.MAX_SPAWN_TIME
	)

func _on_SpawnTimer_timeout():
	get_tree().call_group("bricks", "move_to_next_row")
	$Tween.interpolate_callback(
		self,
		Brick.instance().get_time_until_next_pos(),
		"spawn_bricks_row"
	)
	$Tween.start()
