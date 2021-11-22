extends Control


const Env = preload("res://Env.tscn")
var sound = false

func _ready():
	var scores = Globals.read_scores()
	for score in scores:
		var label = Label.new()
		label.set_text(str(score))
		var font = DynamicFont.new()
		font.font_data = load("res://Assets/Andale Mono.ttf")
		font.size = 64
		label.set("custom_fonts/font", font)

		$CenterContainer/VBoxContainer/ScoresContainer.add_child(label)

func _on_SoundOnOff_toggled(new_state):
	self.sound = new_state

func _on_StartButton_pressed():
	get_tree().get_root().get_node("StartGameMenu").queue_free()
	var env = Env.instance()
	env.get_node("AudioStreamPlayer").autoplay = self.sound
	get_tree().get_root().add_child(env)
