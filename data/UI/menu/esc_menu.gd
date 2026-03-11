extends CanvasLayer

@onready var options = preload("res://data/UI/menu/configs.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Global.escMenu = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Panel.visible == false:
		pass
	
	elif visible == true and Input.is_action_just_pressed("ui_cancel"):
		visible = false
		get_tree().paused = false
		#Global.camera.zoom = Vector2(1.5,1.5)
	
	elif Input.is_action_just_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		#Global.camera.zoom = Vector2(1.0,1.0)
		

		


func retornar_ao_jogo() -> void:
	hide()
	get_tree().paused = false

func opcoes() -> void:
	$Panel.hide()
	add_child(options)
	await child_exiting_tree
	$Panel.visible = true


func voltar_ao_mapa() -> void:
	Global.voltar_ao_menu()
	hide()
	get_tree().root.remove_child(self)



func fechar_o_jogo() -> void:
	get_tree().quit()
