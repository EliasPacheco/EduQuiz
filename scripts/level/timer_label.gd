extends Label


var time = 4
var timer_on = false

func _ready():
	mostrar(false) 


func _process(delta):
	if(timer_on):
		time -= delta
	
	var secs = fmod(time, 60)
	
	var time_passed = "%02d" % [secs]
	text = time_passed
	
	pass
	
	
func mostrar(is_visible):
	for node in get_children():
		node.visible = is_visible


func _on_resume_pressed():
	timer_on = true
	yield(get_tree().create_timer(4), "timeout")
	timer_on = false
	mostrar(false)
	TelaPause.get_tree().paused = false
	time = 4
	pass

