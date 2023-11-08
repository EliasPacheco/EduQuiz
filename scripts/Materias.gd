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
		get_tree().change_scene("res://cena/portugues.tscn")
