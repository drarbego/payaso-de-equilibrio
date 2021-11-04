extends KinematicBody2D

var speed = 950
var damage_color = Color(1, 0, 0)
var color_change_time = 1.5

var equilibrium = 100
var equilibrium_limit = 0.2
var equilibrium_increase_unit = 15
var equilibrium_decrease_unit = -30
var bullets = 3

signal fell
signal shot(dir)

class_name Player

enum {
	AIMING,
	BALANCING,
	HURTING,
	FALLING
}

var state = BALANCING


func _physics_process(delta):
	var inclination = self.get_inclination()
	var motion = Vector2.ZERO if self.state == FALLING else Vector2(inclination, 0) * self.speed
	var __ = self.move_and_slide(motion)

	var equilibrium_delta = equilibrium_decrease_unit if abs(inclination) > equilibrium_limit else equilibrium_increase_unit
	equilibrium = clamp(equilibrium + equilibrium_delta * delta, 0, 100)

	if equilibrium >= 80 and $AnimatedSprite.animation != "normal":
		$AnimatedSprite.play("normal")
	elif equilibrium < 80 and equilibrium > 50 and $AnimatedSprite.animation != "mid":
		$AnimatedSprite.play("mid")
	elif equilibrium <= 50 and $AnimatedSprite.animation != "low":
		$AnimatedSprite.play("low")

	if equilibrium <= 0:
		emit_signal("fell")

func _unhandled_input(event):
	if event.is_action_pressed("shoot") and self.bullets > 0:
		self.state = AIMING

	if event.is_action_released("shoot"):
		var shoot_dir = (get_global_mouse_position() - self.global_position).normalized()

		if self.bullets > 0 and shoot_dir.angle() < 0 and self.state == AIMING:
			self.decrease_bullets()
			emit_signal("shot", shoot_dir)
		self.state = BALANCING

func increase_bullets():
	self.bullets += 1

func decrease_bullets():
	self.bullets -= 1

func get_inclination():
	var inclination = (
		Input.get_accelerometer().x
		+ (int(Input.is_action_pressed("ui_right")) * Globals.MAX_ACC)
		- (int(Input.is_action_pressed("ui_left")) * Globals.MAX_ACC)
	)
	return clamp(inclination, -Globals.MAX_ACC, Globals.MAX_ACC) / Globals.MAX_ACC

func _on_Hitbox_body_entered(body):
	if body is Obstacle:
		self.handle_hit(body)
	elif body is Projectile:
		if not body.is_queued_for_deletion():
			self.increase_bullets()
		body.queue_free()

func _process(delta):
	update()
	$ProgressBar.value = self.equilibrium

func _draw():
	if self.state == AIMING:
		var arrow_end = self.position.direction_to(get_global_mouse_position()) * 250
		draw_line(Vector2.ZERO, arrow_end, Color.white, 2)

func handle_hit(obstacle):
	self.equilibrium -= 30
