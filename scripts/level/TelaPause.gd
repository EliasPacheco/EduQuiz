extends CanvasLayer

var audio_manager_instance
func _ready():
	mostrar(false) 
	
func mostrar(is_visible):
	for node in get_children():
		node.visible = is_visible
		

func _on_resume_pressed():
	$timer_label.show()
	yield(get_tree().create_timer(4), "timeout")
	$pause.hide()
	$resume.hide()
	$menu.hide()
	$timer_label.hide()
	
	
func start_background_audio():
	var audio_stream = load("res://audio/sound.ogg")
	audio_manager_instance.play_sound(audio_stream)

func _on_menu_pressed():
	mostrar(false)
	Global.correct = 0
	get_tree().paused = false
	Global.gameState = false

	# Obtenha uma referência válida para o AudioManager
	audio_manager_instance = get_tree().get_root().get_node("AudioManager")
	if audio_manager_instance == null:
		var audio_manager_scene = preload("res://cena/AudioManager.tscn")
		audio_manager_instance = audio_manager_scene.instance()
		get_tree().get_root().add_child(audio_manager_instance)

	# Salve a posição de reprodução antes de mudar a cena
	if audio_manager_instance != null:
		audio_manager_instance.save_playback_position()

	# Mude a cena
	get_tree().change_scene("res://cena/Menu.tscn")

	# Retome a música de fundo na cena do menu
	if audio_manager_instance != null:
		audio_manager_instance.resume_background_audio()


func _on_pause_pressed():
	if Global.gameState:
		mostrar(!get_tree().paused)
		$timer_label.hide()
		get_tree().paused = !get_tree().paused
