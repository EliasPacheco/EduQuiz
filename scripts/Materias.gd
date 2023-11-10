extends Node2D

var buttons := []

func _ready():
	for _button in $botoes.get_children():
		buttons.append(_button)
		_button.focus_mode = Button.FOCUS_NONE
		_button.connect("mouse_entered", self, "_on_button_mouse_entered", [_button])
		_button.connect("mouse_exited", self, "_on_button_mouse_exited", [_button])

func _on_button_mouse_entered(button):
	button.modulate = Color(1.0, 0.0, 0.0) # Muda a cor do botão para vermelho quando o mouse entra

func _on_button_mouse_exited(button):
	button.modulate = Color(1.0, 1.0, 1.0) # Restaura a cor original (preto) do botão quando o mouse sai


func _on_port_pressed():
	$click.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://cena/portugues.tscn")
		


func _on_mat_pressed():
	$click.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://cena/matematica.tscn")

func _on_geo_pressed():
	$click.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://cena/geografia.tscn")

func _on_hist_pressed():
	$click.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://cena/historia.tscn")

func _on_port_mouse_entered():
	$Seta.show()
	var escolha = $escolha
	escolha.play()
	escolha.volume_db = -28

func _on_port_mouse_exited():
	$Seta.hide()

func _on_mat_mouse_entered():
	$Seta2.show()
	var escolha = $escolha
	escolha.play()
	escolha.volume_db = -28

func _on_mat_mouse_exited():
	$Seta2.hide()

func _on_geo_mouse_entered():
	$Seta3.show()
	var escolha = $escolha
	escolha.play()
	escolha.volume_db = -28

func _on_geo_mouse_exited():
	$Seta3.hide()

func _on_hist_mouse_entered():
	$Seta4.show()
	var escolha = $escolha
	escolha.play()
	escolha.volume_db = -28

func _on_hist_mouse_exited():
	$Seta4.hide()


func _on_back_pressed():
	get_tree().change_scene("res://cena/Menu.tscn")
