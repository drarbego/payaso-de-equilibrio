extends KinematicBody2D


class_name Brick

const Obstacle = preload("res://Bricks/Obstacle.tscn")

var target_pos = Vector2.ZERO
var is_moving = false
var speed = 100
var is_aggresive = false
var health = 3
var min_spawn_time = 3
var max_spawn_time = 15

signal destroyed

func init(
	_position,
	_is_aggresive,
	_health,
	_min_spawn_time,
	_max_spawn_time
	):
	self.position = _position
	self.is_aggresive = _is_aggresive
	self.health = _health
	self.min_spawn_time = _min_spawn_time
	self.max_spawn_time = _max_spawn_time

	return self

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("is_aggresive", self.is_aggresive)
	$Sprite.material.set_shader_param("health", self.health)
	if self.is_aggresive:
		self.start_timer()

func _on_HitBox_body_entered(body):
	if not body.is_in_group("projectiles"):
		return

	self.damaged()

func damaged():
	self.health -= 1
	$Sprite.material.set_shader_param("health", self.health)
	if health <= 0:
		self.destroy()

func destroy():
	emit_signal("destroyed")
	self.queue_free()

func start_timer():
	$ObstacleTimer.wait_time = (max_spawn_time - min_spawn_time) * randf() + min_spawn_time
	$ObstacleTimer.start()

func _on_ObstacleTimer_timeout():
	self.spawn_obstacle()
	self.damaged()
	self.start_timer()

func spawn_obstacle():
	var obstacle = Obstacle.instance().init(self.global_position)
	get_node("../../Obstacles").add_child(obstacle)

func move_to_next_row():
	self.target_pos = self.position + Vector2(0, self.get_height())
	self.is_moving = true

func get_time_until_next_pos():
	return self.get_height() / self.speed

func get_width():
	return ($CollisionShape2D.shape.extents.x+2) * 2

func get_height():
	return ($CollisionShape2D.shape.extents.y+2) * 2

func _physics_process(delta):
	if not self.is_moving:
		return

	move_and_slide(self.position.direction_to(self.target_pos) * self.speed)
	if  self.position >= self.target_pos:
		self.position = self.target_pos
		self.is_moving = false
