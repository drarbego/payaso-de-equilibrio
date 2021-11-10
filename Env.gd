extends Node2D

const projectile_class = preload("res://BaseProjectile.tscn")
const ammo_class = preload("res://Ammo.tscn")
const cloud_texture = preload("res://Assets/Background/Cloud_01.png")
const GameOverMenu = preload("res://GameOverMenu.tscn")

export(float) var CLOUD_ANIMATION_SPEED = 300
var score = 0

func _ready():
	randomize()
	$Score/Points.set_text(str(self.score))

func add_score():
	self.score += 10
	$Score/Points.set_text(str(self.score))

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

func _on_Payasito_shot(dir):
	var projectile = projectile_class.instance()
	projectile.dir = dir
	projectile.global_position = $Payasito.global_position + dir * 100
	$Projectiles.add_child(projectile)

func game_over():
	get_tree().get_root().get_node("Env").queue_free()
	var game_over_menu = GameOverMenu.instance()
	get_tree().get_root().add_child(game_over_menu)
