extends KinematicBody2D

var speed = 950
var damage_color = Color(1, 0, 0)
onready var original_color = $Polygon2D.color
var color_change_time = 1.5
var equilibrium = 100

class_name Player


func _physics_process(_delta):
	var inclination = self.get_inclination()
	var motion = Vector2(inclination, 0) * self.speed
	self.move_and_slide(motion)

func get_inclination():
	var half_max_acc = Globals.MAX_ACC / 2
	return clamp(Input.get_accelerometer().x, -half_max_acc, half_max_acc) / half_max_acc

func _on_Hitbox_body_entered(body):
	if body is Obstacle:
		self.handle_hit(body)

func handle_hit(obstacle):
	self.equilibrium -= 10
	$Tween.interpolate_property($Polygon2D, "color", original_color, damage_color, color_change_time / 2)
	$Tween.interpolate_callback(self, color_change_time / 2, "transition_to_idle")
	$Tween.start()

func transition_to_idle():
	$Tween.interpolate_property($Polygon2D, "color", damage_color, original_color, color_change_time / 2)
	$Tween.start()
