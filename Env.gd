extends Node2D

var obstacle_class = preload("res://Obstacle.tscn")

var spawn_timer = Timer.new()
var obstacle_spawn_time = 0.75

func _ready():
	randomize()
	spawn_timer.set_wait_time(obstacle_spawn_time)
	spawn_timer.connect("timeout", self, "spawn_obstacle")
	spawn_timer.set_autostart(true)
	add_child(spawn_timer)

func spawn_obstacle():
	var spawn_length = ($ObstacleSpawner/End.position - $ObstacleSpawner/Start.position).x
	var spawn_pos = Vector2($ObstacleSpawner/Start.position.x + randf() * spawn_length, $ObstacleSpawner/Start.position.y)
	var obstacle = obstacle_class.instance()
	obstacle.position = spawn_pos
	add_child(obstacle)

func _process(delta):
	var inclination = get_inclination()
	var rot = 90 * inclination
	$TiltIndicator.rotation_degrees = rot
	$Label.set_text(str(rot))

func get_inclination():
	var half_max_acc = Globals.MAX_ACC / 2
	return clamp(Input.get_accelerometer().x, -half_max_acc, half_max_acc) / half_max_acc

func _on_ObstacleDeleter_body_entered(body):
	if body is Obstacle:
		body.queue_free()

func _on_LeftLimitDetector_body_entered(body):
	if body is Player:
		$LimitDetectors/LimitTimer.start()

func _on_LeftLimitDetector_body_exited(body):
	if body is Player:
		$LimitDetectors/LimitTimer.stop()

func _on_RightLimitDetector_body_entered(body):
	if body is Player:
		$LimitDetectors/LimitTimer.start()

func _on_RightLimitDetector_body_exited(body):
	if body is Player:
		$LimitDetectors/LimitTimer.stop()

func _on_LimitTimer_timeout():
	game_over()

func _on_Payasito_fell():
	game_over()

func game_over():
	get_tree().change_scene("res://GameOverMenu.tscn")
