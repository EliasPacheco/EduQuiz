extends Node2D

var popup_instance

func _ready():
	var audio_stream = load("res://cena/audio.tscn")  # Assumindo que é um AudioStream
	AudioManager.play_sound(audio_stream)

func _on_start_pressed():
	popup_instance = preload("res://cena/popup_name.tscn").instance()
	add_child(popup_instance)

func _on_comojogar_pressed():
	get_tree().change_scene("res://cena/comojogar.tscn")

func _on_recorde_pressed():
	get_tree().change_scene("res://cena/Ranking.tscn")
