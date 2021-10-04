extends Node2D

const obstacle_class = preload("res://Obstacle.tscn")
const projectile_class = preload("res://BaseProjectile.tscn")
const ammo_class = preload("res://Ammo.tscn")
const cloud_texture = preload("res://Assets/Background/Cloud_01.png")

var spawn_timer = Timer.new()
var obstacle_spawn_time = 2

export(float) var CLOUD_ANIMATION_SPEED = 300
var score = 0

func _ready():
	randomize()
	spawn_timer.set_wait_time(obstacle_spawn_time)
	spawn_timer.connect("timeout", self, "spawn_obstacle")
	spawn_timer.set_autostart(true)
	add_child(spawn_timer)
	$Score/Points.set_text(str(self.score))

func _on_ScoreTimer_timeout():
	self.score += 100
	$Score/Points.set_text(str(self.score))


func spawn_obstacle():
	var spawn_length = ($ObstacleSpawner/End.position - $ObstacleSpawner/Start.position).x
	var spawn_pos = Vector2($ObstacleSpawner/Start.position.x + randf() * spawn_length, $ObstacleSpawner/Start.position.y)
	var obstacle = obstacle_class.instance()
	obstacle.position = spawn_pos
	obstacle.connect("destroyed", self, "_on_obstacle_destroyed")
	$Obstacles.add_child(obstacle)

func _on_obstacle_destroyed(points):
	self.score += points
	$Score/Points.set_text(str(score))

func _process(delta):
	animate_clouds(delta)

func animate_clouds(delta):
	for cloud in $Clouds.get_children():
		cloud.position.x += CLOUD_ANIMATION_SPEED * delta
		if cloud.position.x >= get_viewport_rect().size.x + cloud.texture.get_width() / 2:
			cloud.queue_free()

func _on_CloudTimer_timeout():
	var sprite = Sprite.new()
	sprite.texture = cloud_texture
	var x = (sprite.texture.get_width() / 2) * -1
	var y = randf() * get_viewport_rect().size.y
	sprite.position = Vector2(x, y)
	$Clouds.add_child(sprite)

func get_inclination():
	var half_max_acc = Globals.MAX_ACC / 2
	return clamp(Input.get_accelerometer().x, -half_max_acc, half_max_acc) / half_max_acc

func _on_ObstacleDeleter_body_entered(body):
	if body is Obstacle:
		body.queue_free()
	if body is Projectile:
		var ammo = ammo_class.instance()
		ammo.position = Vector2(body.position.x, $Payasito.position.y)
		add_child(ammo)
		body.queue_free()
	if body is Brick:
		game_over()


func _on_GameOverTimer_timeout():
	game_over()

func _on_LeftLimitDetector_body_entered(body):
	if body is Player and body.state != $Payasito.FALLING:
		$GameOverTimer.start()
		$Payasito.state = $Payasito.FALLING
		$Payasito/AnimationPlayer.play("falling_left")

func _on_RightLimitDetector_body_entered(body):
	if body is Player and body.state != $Payasito.FALLING:
		$GameOverTimer.start()
		$Payasito.state = $Payasito.FALLING
		$Payasito/AnimationPlayer.play("falling_right")

func _on_Payasito_fell():
	$GameOverTimer.start()
	$Payasito.state = $Payasito.FALLING
	$Payasito/AnimationPlayer.play("falling")

func _on_Payasito_shot(dir, speed_factor):
	var projectile = projectile_class.instance()
	projectile.dir = dir
	projectile.global_position = $Payasito.global_position + dir * 100
	projectile.speed = projectile.max_speed * speed_factor
	$Projectiles.add_child(projectile)

func game_over():
	get_tree().change_scene("res://GameOverMenu.tscn")
