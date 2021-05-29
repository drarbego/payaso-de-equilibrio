extends KinematicBody2D

class_name Projectile

export (float) var speed = 1000
var dir = Vector2.UP

func _ready():
    var screen_size = get_viewport_rect().size
    var screen_diagonal = sqrt(screen_size.y * screen_size.y + screen_size.x * screen_size.x)
    var wait_time = screen_diagonal / self.speed
    $Timer.set_wait_time(wait_time)

func _physics_process(delta):
    var collision = move_and_collide(dir * speed * delta)

    if collision and collision.collider is Obstacle:
        collision.collider.queue_free()
        self.queue_free()

func _on_Timer_timeout():
    if not self.is_queued_for_deletion():
        self.queue_free()
