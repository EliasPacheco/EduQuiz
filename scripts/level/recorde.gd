extends Label


func _ready():
	Global.carregar_jogo()
	text = String(Global.recorde)
