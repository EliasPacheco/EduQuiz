extends Control

var rankingContainer
var materiaOptionButton

var font_data_1 = load("res://legendas/Roboto-Black.ttf")
var font_data_2 = load("res://legendas/Roboto-Medium.ttf")
var font_size_1 = 26
var font_size_2 = 16

var lista_registros = []  # Inicialize como uma lista vazia

func _ready():
	materiaOptionButton = OptionButton.new()
	add_child(materiaOptionButton)
	carregar_materias()
	
	rankingContainer = VBoxContainer.new()
	rankingContainer.rect_min_size = Vector2(400, 200) 
	add_child(rankingContainer)
	center_ranking()
	
	var selected_index = materiaOptionButton.selected
	if selected_index >= 0:
		var selected_materia = materiaOptionButton.get_item_text(selected_index)
		var registros_filtrados = filtrar_registros_por_materia(selected_materia)
		carregar_ranking(registros_filtrados)

func carregar_materias():
	var arquivo_json = ler_arquivo_json("user://jogosalvo.save")
	if arquivo_json.empty():
		print("Erro ao carregar o arquivo")
		return

	var json_data = JSON.parse(arquivo_json)
	if json_data.error != OK:
		print("Erro ao analisar o JSON")
		return

	if json_data.result.has("registros") and json_data.result["registros"] is Array:
		lista_registros = json_data.result["registros"].duplicate()  # Duplique para evitar problemas com referência
		var materias_array = []

		for registro in lista_registros:
			if not registro["materia"] in materias_array:
				materias_array.append(registro["materia"])

		materias_array.sort()

		for materia in materias_array:
			materiaOptionButton.add_item(str(materia))

		materiaOptionButton.connect("item_selected", self, "_on_materia_selected")
	else:
		print("Chave 'registros' ausente ou não é um array no JSON")

func _on_materia_selected(index):
	var selected_materia = materiaOptionButton.get_item_text(index)
	print("Matéria selecionada:", selected_materia)

	var registros_filtrados = filtrar_registros_por_materia(selected_materia)
	carregar_ranking(registros_filtrados)

func filtrar_registros_por_materia(materia):
	var registros_filtrados = []
	for registro in lista_registros:
		if registro["materia"] == materia:
			registros_filtrados.append(registro)
	return registros_filtrados

func _compare_registros(reg1, reg2):
	return reg2.recorde - reg1.recorde

func carregar_ranking(registros = null):
	for child in rankingContainer.get_children():
		rankingContainer.remove_child(child)

	var registros_a_usar = registros if registros != null else lista_registros

	registros_a_usar.sort_custom(self, "_compare_registros")

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

	for i in range(min(10, registros_a_usar.size())):
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
		nomeLabel.text = registros_a_usar[i].nome
		nomeLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dynamic_font_2.font_data = font_data_2
		nomeLabel.add_font_override("font", dynamic_font_2)
		nomeLabel.modulate = Color(0, 0, 0)
		registroContainer.add_child(nomeLabel)

		var separador2 = VSeparator.new()
		registroContainer.add_child(separador2)
		separador2.modulate = Color(0, 0, 0)

		var pontuacaoLabel = Label.new()
		pontuacaoLabel.text = str(registros_a_usar[i].recorde)
		dynamic_font_2.font_data = font_data_2
		pontuacaoLabel.add_font_override("font", dynamic_font_2)
		pontuacaoLabel.modulate = Color(0, 0, 0)
		registroContainer.add_child(pontuacaoLabel)

func ler_arquivo_json(path: String) -> String:
	var arquivo = File.new()
	if arquivo.file_exists(path):
		arquivo.open(path, File.READ)
		return arquivo.get_as_text()
	return ""

func center_ranking():
	var viewport_size = get_viewport_rect().size
	var button_size = materiaOptionButton.rect_min_size
	var container_size = rankingContainer.rect_min_size
	
	materiaOptionButton.rect_position = Vector2((viewport_size.x - container_size.x) / 34,  container_size.y / 1.2) 

	rankingContainer.rect_position = Vector2((viewport_size.x - container_size.x) / 7,  container_size.y)

func _on_menu_pressed():
	get_tree().change_scene("res://cena/Menu.tscn")
