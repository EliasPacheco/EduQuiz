extends Node2D

var popup_instance
var audio_manager_instance

var buttons := []

func _ready():
	for _button in $buttons.get_children():
		buttons.append(_button)
		_button.focus_mode = Button.FOCUS_NONE
	audio_manager_instance = get_tree().get_root().get_node("AudioManager")
	if audio_manager_instance == null:
		var audio_manager_scene = preload("res://cena/AudioManager.tscn")
		audio_manager_instance = audio_manager_scene.instance()
		get_tree().get_root().add_child(audio_manager_instance)

	# Inicie a música apenas se não estiver sendo reproduzida
	if not audio_manager_instance.is_background_audio_playing():
		audio_manager_instance.start_background_audio()

	# Adicione a verificação aqui
	if not audio_manager_instance.is_background_audio_playing():
		start_background_audio()

func start_background_audio():
	var audio_stream = load("res://audio/sound.ogg")
	audio_manager_instance.play_sound(audio_stream)

func _on_start_pressed():
	popup_instance = preload("res://cena/popup_name.tscn").instance()
	add_child(popup_instance)

func _on_comojogar_pressed():
	# Salva o estado da música antes de mudar de cena
	audio_manager_instance.save_playback_position()
	get_tree().change_scene("res://cena/comojogar.tscn")

func _on_recorde_pressed():
	# Salva o estado da música antes de mudar de cena
	audio_manager_instance.save_playback_position()
	get_tree().change_scene("res://cena/Ranking.tscn")


func _on_git_pressed():
	var url = "https://github.com/EliasPacheco/EduQuiz"
	OS.shell_open(url)

func _on_link_pressed():
	var url = "https://www.linkedin.com/in/elias-pacheco-450373218/?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"
	OS.shell_open(url)
