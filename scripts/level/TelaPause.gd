extends CanvasLayer


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
	
	

func _on_menu_pressed():
	mostrar(false)
	Global.correct = 0
	get_tree().paused = false
	Global.gameState = false
	get_tree().change_scene("res://cena/Menu.tscn")


func _on_pause_pressed():
	if Global.gameState:
		mostrar(!get_tree().paused)
		$timer_label.hide()
		get_tree().paused = !get_tree().paused
