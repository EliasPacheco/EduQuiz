extends Node

enum QuestionType { TEXT, IMAGE, VIDEO, AUDIO }

export(Resource) var bd_quiz
export(Color) var cor_certa
export(Color) var cor_errada


var buttons := []
var index := 0
var quiz_shuffle := []

var timer := 30

var answer_selected = false

var audio_manager_instance

onready var question_texts := $question_info/txt_question
onready var question_image := $question_info/image_holder/question_image
onready var question_video := $question_info/image_holder/question_video
onready var question_audio := $question_info/image_holder/question_audio

func _ready():
	Global.gameState = true
	AudioManager.stop_current_sound()
	for _button in $question_holder.get_children():
		buttons.append(_button)
		_button.focus_mode = Button.FOCUS_NONE
		
	var game = $game
	game.play()
	game.volume_db = -22
	quiz_shuffle = randomize_array(bd_quiz.bd)
	quiz_shuffle.resize(10) 
	$txt_qntd.text = str(index, "/", bd_quiz.bd.size())
	load_quiz()

func load_quiz() -> void:
	if index >= bd_quiz.bd.size():
		game_over()
		return
	#texto pergunta
	question_texts.text = str(quiz_shuffle[index].question_info)
	
	#respostas randomizadas
	var options = randomize_array(bd_quiz.bd[index].options)
	
	#botões
	for i in buttons.size():
		var button = buttons[i]
		button.text = ""  # remove o texto do botão
		var label = button.get_node("Label")  # obtém o nó do Label dentro do Button
		label.text = str(options[i])  # define o texto do Label como a opção de resposta
		button.connect("pressed",self, "buttons_answer", [button])
	
	match bd_quiz.bd[index].type:
		QuestionType.TEXT:
			$question_info/image_holder.hide()
			
		QuestionType.IMAGE:
			$question_info/image_holder.show()
			question_image.texture = bd_quiz.bd[index].question_image
			
		QuestionType.VIDEO:
			$question_info/image_holder.show()
			question_video.stream = bd_quiz.bd[index].question_video
			question_video.play()
		
		QuestionType.AUDIO:
			$question_info/image_holder.show()
			question_audio.stream = bd_quiz.bd[index].question_audio
			question_audio.play()
	

func buttons_answer(button):
	if answer_selected :
		return

	answer_selected  = true

	var selected_option = button.get_node("Label").text  # Obtém a opção selecionada pelo usuário

	if bd_quiz.bd[index].correct == selected_option:  # Verifica se a resposta selecionada está correta
		var click = $click
		click.play()
		click.volume_db = -5
		button.modulate = cor_certa
		Global.correct += 1
		Global.pontos += 1
		$valor.text = str(int($valor.text) + 1)
		if Global.pontos > Global.recorde:
			Global.recorde = Global.pontos
			Global.salvar_jogo()
		var correto = $audio_correto
		correto.play()
		correto.volume_db = -10
	else: 
		var click = $click
		click.play()
		click.volume_db = -5
		button.modulate = cor_errada
		var errado = $audio_errado
		errado.play()
		errado.volume_db = -10

		# Encontra o botão com a resposta correta
		for bt in buttons:
			if bd_quiz.bd[index].correct == bt.get_node("Label").text:
				bt.modulate = cor_certa  # Destaca o botão com a resposta correta

	$redondo.value = 0
	_next_question()

	
func _next_question():
	$txt_qntd.text = str(index + 1, "/", bd_quiz.bd.size())
	question_audio.stop()
	question_video.stop()
	timer = 30
	
	yield(get_tree().create_timer(1.3), "timeout")
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
		answer_selected = false  # Desbloqueia o botão
		
	question_audio.stream = null
	question_video.stream = null
	
	index += 1
	load_quiz()


func randomize_array(array : Array) -> Array:
	randomize()
	var array_temp := array
	array_temp.shuffle()
	return array_temp

func game_over():
	var applause_player = $aplausos
	applause_player.play()
	applause_player.volume_db = -16
	$game.stop()
	$pause.hide()
	$valor.hide()
	$Acertivas.hide()
	$game_over.show()
	$game_over/txt_result.text = str(Global.correct, "/", bd_quiz.bd.size())
	$txt_qntd.hide()
	$timer.stop()
	$redondo.hide()
	$txt_timer.hide() 
	$timer.disconnect("timeout", self, "_on_timer_timeout")
	

func _on_timer_timeout():
	var secs = fmod(timer, 60)
	var time_passed = "%02d" % [secs]
	$txt_timer.text = time_passed
	$redondo.value += 1
	timer -= 1
	
	if timer < 0:
		$redondo.value = 0
		_next_question()
	
	
func _on_btn_menu_pressed():
	Global.correct = 0
	Global.pontos = 0
	Global.recorde = 0
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


func _on_button_option_1_mouse_entered():
	$question_holder/button_option_1/Seta.show()

func _on_button_option_1_mouse_exited():
	$question_holder/button_option_1/Seta.hide()

func _on_button_option_2_mouse_entered():
	$question_holder/button_option_2/Seta2.show()

func _on_button_option_2_mouse_exited():
	$question_holder/button_option_2/Seta2.hide()

func _on_button_option_3_mouse_entered():
	$question_holder/button_option_3/Seta3.show()

func _on_button_option_3_mouse_exited():
	$question_holder/button_option_3/Seta3.hide()

func _on_button_option_4_mouse_entered():
	$question_holder/button_option_4/Seta4.show()

func _on_button_option_4_mouse_exited():
	$question_holder/button_option_4/Seta4.hide()

