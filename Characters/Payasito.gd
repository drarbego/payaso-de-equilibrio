extends KinematicBody2D

var speed = 950
var damage_color = Color(1, 0, 0)
var color_change_time = 1.5

var equilibrium = 100
var equilibrium_limit = 0.2
var equilibrium_increase_unit = 10
var equilibrium_decrease_unit = -10

signal fell
signal shot(dir)

class_name Player


func _physics_process(delta):
	var inclination = self.get_inclination()
	var motion = Vector2(inclination, 0) * self.speed
	var __ = self.move_and_slide(motion)

	var equilibrium_delta = equilibrium_decrease_unit if abs(inclination) > equilibrium_limit else equilibrium_increase_unit
	equilibrium = clamp(equilibrium + equilibrium_delta * delta, -5, 100)

	if equilibrium >= 60 and $AnimatedSprite.animation != "normal":
		$AnimatedSprite.play("normal")
	elif equilibrium < 60 and equilibrium > 30 and $AnimatedSprite.animation != "mid":
		$AnimatedSprite.play("mid")
	elif equilibrium <= 30 and $AnimatedSprite.animation != "low":
		$AnimatedSprite.play("low")

	if equilibrium <= 0:
		emit_signal("fell")

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		# trigger load
		pass
	if event.is_action_released("shoot"):
		var shoot_dir = (get_global_mouse_position() - self.global_position).normalized()
		emit_signal("shot", shoot_dir)

func get_inclination():
	return clamp(Input.get_accelerometer().x, -Globals.MAX_ACC, Globals.MAX_ACC) / Globals.MAX_ACC

func _on_Hitbox_body_entered(body):
	if body is Obstacle:
		self.handle_hit(body)

func _process(_delta):
	$ProgressBar.value = self.equilibrium

func handle_hit(obstacle):
	self.equilibrium -= 30
