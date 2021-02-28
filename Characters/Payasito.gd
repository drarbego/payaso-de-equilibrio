extends KinematicBody2D

var speed = 1000
var damage_color = Color(1, 0, 0)
onready var original_color = $Polygon2D.color
var color_change_time = 0.5


func _physics_process(_delta):
	var inclination = self.get_inclination()
	var motion = Vector2(inclination, 0) * self.speed
	self.move_and_slide(motion)

func get_inclination():
	var half_max_acc = Globals.MAX_ACC / 2
	return clamp(Input.get_accelerometer().x, -half_max_acc, half_max_acc) / half_max_acc

func _on_Hitbox_body_entered(body):
	if body is Obstacle:
		$Tween.interpolate_property($Polygon2D, "color", original_color, damage_color, color_change_time / 2)
		$Tween.interpolate_callback(self, color_change_time / 2, "change_color")
		$Tween.start()

func change_color():
	$Tween.interpolate_property($Polygon2D, "color", damage_color, original_color, color_change_time / 2)
	$Tween.start()

