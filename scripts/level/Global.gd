extends Node

var gameState
var lista_registros = []
var recorde = 0
var correct := 0
var pontos = 0
var nome = ""
var materia = ''

func salvar():
	var dic_salvar = {
		"recorde": recorde,
		"nome": nome,
		"materia": materia,
	}
	return dic_salvar

func salvar_jogo():
	var jogo_salvo = File.new()
	jogo_salvo.open("user://jogosalvo.save", File.WRITE)

	var registro = {
		"nome": nome,
		"recorde": recorde,
		"materia": materia,
	}

	var indice = -1
	for i in range(lista_registros.size()):
		if lista_registros[i].nome == nome:
			indice = i
			break

	if indice != -1:
		if recorde > lista_registros[indice].recorde:
			lista_registros[indice] = registro  # Atualiza o registro apenas se o novo recorde for maior
	else:
		lista_registros.append(registro)  # Adiciona um novo registro

	var dic_salvar = {
		"registros": lista_registros
	}

	jogo_salvo.store_string(to_json(dic_salvar))
	jogo_salvo.close()


func carregar_jogo():
	var jogo_salvo = File.new()
	if not jogo_salvo.file_exists("user://jogosalvo.save"):
		print("Erro ao carregar o arquivo")
		return

	jogo_salvo.open("user://jogosalvo.save", File.READ)
	var arquivo_json = jogo_salvo.get_as_text()
	var json_data = JSON.parse(arquivo_json)
	if json_data.error != OK:
		print("Erro ao analisar o JSON")
		return

	var registros_salvos = json_data.result.registros
	
	if lista_registros.empty():
		lista_registros = registros_salvos
	else:
		# Adicionar apenas os registros que não existem na lista atual
		for registro in registros_salvos:
			var registro_existente = false
			for i in range(lista_registros.size()):
				if lista_registros[i].nome == registro.nome:
					registro_existente = true
					break
			if not registro_existente:
				lista_registros.append(registro)
	
	var indice = -1
	for i in range(lista_registros.size()):
		if lista_registros[i].nome == nome:
			indice = i
			break
	
	if indice != -1:
		recorde = lista_registros[indice].recorde
	else:
		recorde = 0  # Define o recorde como zero se o nome não existir na lista
		var novo_registro = {
			"nome": nome,
			"recorde": recorde,
			"materia": materia,
		}
		lista_registros.append(novo_registro)

	jogo_salvo.close()
