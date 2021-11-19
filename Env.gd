extends Node2D

const projectile_class = preload("res://BaseProjectile.tscn")
const cloud_texture = preload("res://Assets/Background/Cloud_01.png")
const GameOverMenu = preload("res://GameOverMenu.tscn")

export(float) var CLOUD_ANIMATION_SPEED = 300
var hiscore = 0
const MAX_HISCORES = 5

func _ready():
	randomize()
	$Score/Points.set_text(str(self.hiscore))

func save_score():
	var scores = self._read_scores()

	var pos = 0
	for score in scores:
		if score < self.hiscore:
			break
		pos += 1

	scores.insert(pos, self.hiscore)

	self._write_scores(scores.slice(0, MAX_HISCORES-1))

func _read_scores():
	var file_descriptor = File.new()

	if not file_descriptor.file_exists("user://hiscores.save"):
		return []

	file_descriptor.open("user://hiscores.save", File.READ)

	var scores = []
	while file_descriptor.get_position() < file_descriptor.get_len() and len(scores) < MAX_HISCORES:
		scores.append(int(file_descriptor.get_line()))
	
	file_descriptor.close()

	return scores

func _write_scores(scores):
	var file_descriptor = File.new()
	file_descriptor.open("user://hiscores.save", File.WRITE)

	for score in scores:
		file_descriptor.store_line(str(score))
		print("saved to file ", str(score))

	file_descriptor.close()

func add_score():
	self.hiscore += 10
	$Score/Points.set_text(str(self.hiscore))

func _on_obstacle_destroyed(points):
	self.hiscore += points
	$Score/Points.set_text(str(hiscore))

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
		body.speed = 0.0
		body.position = Vector2(body.position.x, $Payasito.position.y)
	if body is Brick:
		game_over()

func _on_GameOverTimer_timeout():
	game_over()

func _on_LeftLimitDetector_area_entered(area):
	var area_parent = area.get_parent()

	if area_parent is Player and area_parent.state != $Payasito.FALLING:
		$GameOverTimer.start()
		$Payasito.state = $Payasito.FALLING
		$Payasito/AnimationPlayer.play("falling_left")

func _on_RightLimitDetector_area_entered(area):
	var area_parent = area.get_parent()

	if area_parent is Player and area_parent.state != $Payasito.FALLING:
		$GameOverTimer.start()
		$Payasito.state = $Payasito.FALLING
		$Payasito/AnimationPlayer.play("falling_right")

func _on_Payasito_fell():
	if $Payasito.state != $Payasito.FALLING:
		$GameOverTimer.start()
		$Payasito.state = $Payasito.FALLING
		$Payasito/AnimationPlayer.play("falling")

func _on_Payasito_shot(dir):
	var projectile = projectile_class.instance()
	projectile.dir = dir
	projectile.global_position = $Payasito.global_position + dir * 100
	$Projectiles.add_child(projectile)

func game_over():
	self.save_score()

	get_tree().get_root().get_node("Env").queue_free()
	var game_over_menu = GameOverMenu.instance()
	get_tree().get_root().add_child(game_over_menu)
