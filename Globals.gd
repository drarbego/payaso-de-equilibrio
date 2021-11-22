extends Node

var MAX_ACC = 6.0
const MAX_HISCORES = 5

var BASE_MAX_SPAWN_TIME = 15
var MAX_SPAWN_TIME = BASE_MAX_SPAWN_TIME
var BASE_MIN_SPAWN_TIME = 3
var MIN_SPAWN_TIME = BASE_MIN_SPAWN_TIME
var BASE_BRICK_HEALTH = 3
var BRICK_HEALTH = BASE_BRICK_HEALTH
var BASE_AGGRESIVE_CHANCE = 0.33
var AGGRESIVE_CHANCE = BASE_AGGRESIVE_CHANCE

var DIFFICULTY_DIVISOR = 2000


func adjust_difficulty(score):
    var difficulty_units = score / DIFFICULTY_DIVISOR

    AGGRESIVE_CHANCE = clamp(
        BASE_AGGRESIVE_CHANCE + (difficulty_units * 0.1),
        0,
        0.6
    )
    BRICK_HEALTH = BASE_BRICK_HEALTH + int(difficulty_units)

func read_scores():
	var file_descriptor = File.new()

	if not file_descriptor.file_exists("user://hiscores.save"):
		return []

	file_descriptor.open("user://hiscores.save", File.READ)

	var scores = []
	while file_descriptor.get_position() < file_descriptor.get_len() and len(scores) < MAX_HISCORES:
		scores.append(int(file_descriptor.get_line()))
	
	file_descriptor.close()

	return scores

func write_scores(scores):
	var file_descriptor = File.new()
	file_descriptor.open("user://hiscores.save", File.WRITE)

	for score in scores:
		file_descriptor.store_line(str(score))

	file_descriptor.close()

