extends Control

var lineEdit: LineEdit

func _ready():
	lineEdit = $LineEdit
	$saveButton.connect("pressed", self, "_on_SaveButton_pressed")
	load_game()


func save_name(name: String) -> void:
	if name.strip_edges().empty():
		print("Nome inválido. Não será salvo.")
	else:
		Global.nome = name
		print("Nome salvo: ", name)
		get_tree().change_scene("res://cena/Materias.tscn")


func load_game() -> void:
	Global.carregar_jogo()
	if Global.recorde != 0:
		print("Arquivo carregado com sucesso")
	else:
		print("Nenhum arquivo encontrado. Iniciando novo jogo.")


func _on_saveButton_pressed():
	var name = lineEdit.text

	if name.strip_edges().empty():  # Verifica se o texto está vazio
		# O LineEdit está vazio, exibe uma mensagem de erro
		$LineEdit.placeholder_text = "Campo Obrigatório"
		$LineEdit.add_color_override("font_color", Color.red)
		yield(get_tree().create_timer(1.3), "timeout")
		$LineEdit.placeholder_text = "Nome e Sobrenome"
		$LineEdit.add_color_override("font_color", Color.white)
		print("O nome não pode estar vazio!")
	else:
		# O LineEdit contém texto, salva o nome
		save_name(name)

func _on_TextureButton_pressed():
	$ColorRect.hide()
	$LineEdit.hide()
	$saveButton.hide()
	$close.hide()
