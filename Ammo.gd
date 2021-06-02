extends Area2D

func _on_Ammo_body_entered(body):
    if body is Player:
        body.bullets += 1
        self.queue_free()
