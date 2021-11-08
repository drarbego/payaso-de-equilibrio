extends Control


var sound = false


func _on_SoundOnOff_toggled(new_state):
	self.sound = new_state

func _on_Button_pressed():
	get_tree().get_root().get_node("GameOverMenu").queue_free()
	var env = load("res://Env.tscn").instance()
	env.get_node("AudioStreamPlayer").autoplay = self.sound
	get_tree().get_root().add_child(env)
