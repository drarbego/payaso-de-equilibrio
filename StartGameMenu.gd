extends Control


const Env = preload("res://Env.tscn")
var sound = false


func _on_SoundOnOff_toggled(new_state):
	self.sound = new_state

func _on_StartButton_pressed():
	get_tree().get_root().get_node("StartGameMenu").queue_free()
	var env = Env.instance()
	env.get_node("AudioStreamPlayer").autoplay = self.sound
	get_tree().get_root().add_child(env)
