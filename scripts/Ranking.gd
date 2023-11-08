extends Control

var rankingContainer

var font_data_1 = load("res://legendas/Roboto-Black.ttf")

var font_data_2 = load("res://legendas/Roboto-Medium.ttf")

var font_size_1 = 26
var font_size_2 = 16

func _ready():
	rankingContainer = VBoxContainer.new()
	rankingContainer.rect_min_size = Vector2(400, 200)  # Define o tamanho mínimo da caixa vertical
	add_child(rankingContainer)
	carregar_ranking()
	center_ranking()

func carregar_ranking():
	var arquivo_json = ler_arquivo_json("user://jogosalvo.save")
	if arquivo_json.empty():
		print("Erro ao carregar o arquivo")
		return

	var json_data = JSON.parse(arquivo_json)
	if json_data.error != OK:
		print("Erro ao analisar o JSON")
		return

	var lista_registros = json_data.result.registros

	# Ordena os registros em ordem decrescente de pontuação
	for i in range(lista_registros.size() - 1):
		for j in range(lista_registros.size() - 1 - i):
			if lista_registros[j].recorde < lista_registros[j+1].recorde:
				var temp = lista_registros[j]
				lista_registros[j] = lista_registros[j+1]
				lista_registros[j+1] = temp

	# Adiciona o título das colunas
	var tituloContainer = HBoxContainer.new()
	tituloContainer.alignment = VBoxContainer.ALIGN_CENTER
	rankingContainer.add_child(tituloContainer)
	tituloContainer.modulate = Color(0, 0, 0)

	var nomeTituloLabel = Label.new()
	nomeTituloLabel.text = " Nome"
	nomeTituloLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var dynamic_font_1 = DynamicFont.new()
	dynamic_font_1.size = font_size_1
	nomeTituloLabel.modulate = Color(0, 0, 0)
	dynamic_font_1.font_data = font_data_1
	nomeTituloLabel.add_font_override("font", dynamic_font_1)
	tituloContainer.add_child(nomeTituloLabel)


	var pontuacaoTituloLabel = Label.new()
	pontuacaoTituloLabel.text = "Score"
	pontuacaoTituloLabel.modulate = Color(0, 0, 0)
	dynamic_font_1.font_data = font_data_1
	pontuacaoTituloLabel.add_font_override("font", dynamic_font_1)
	tituloContainer.add_child(pontuacaoTituloLabel)

	for i in range(min(10, lista_registros.size())):
		var registroContainer = HBoxContainer.new()
		registroContainer.alignment = VBoxContainer.ALIGN_CENTER
		rankingContainer.add_child(registroContainer)

		var posicao = i + 1
		var posicaoLabel = Label.new()
		posicaoLabel.text = str(posicao)
		var dynamic_font_2 = DynamicFont.new()
		dynamic_font_2.size = font_size_1
		posicaoLabel.modulate = Color(0, 0, 0)
		dynamic_font_2.font_data = font_data_2
		posicaoLabel.add_font_override("font", dynamic_font_2)
		registroContainer.add_child(posicaoLabel)

		var separador = VSeparator.new()
		registroContainer.add_child(separador)
		separador.modulate = Color(0, 0, 0)

		var nomeLabel = Label.new()
		nomeLabel.text = lista_registros[i].nome
		nomeLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dynamic_font_2.font_data = font_data_2
		nomeLabel.add_font_override("font", dynamic_font_2)
		nomeLabel.modulate = Color(0, 0, 0)  # Definir a cor do texto como preto
		registroContainer.add_child(nomeLabel)

		var separador2 = VSeparator.new()
		registroContainer.add_child(separador2)
		separador2.modulate = Color(0, 0, 0)

		var pontuacaoLabel = Label.new()
		pontuacaoLabel.text = str(lista_registros[i].recorde)
		dynamic_font_2.font_data = font_data_2
		pontuacaoLabel.add_font_override("font", dynamic_font_2)
		pontuacaoLabel.modulate = Color(0, 0, 0)  # Definir a cor do texto como preto
		registroContainer.add_child(pontuacaoLabel)

func ler_arquivo_json(path: String) -> String:
	var arquivo = File.new()
	if arquivo.file_exists(path):
		arquivo.open(path, File.READ)
		return arquivo.get_as_text()
	return ""

func center_ranking():
	var viewport_size = get_viewport_rect().size
	var container_size = rankingContainer.rect_min_size

	rankingContainer.rect_position = Vector2((viewport_size.x - container_size.x) / 7,  container_size.y)


func _on_menu_pressed():
	get_tree().change_scene("res://cena/Menu.tscn")
