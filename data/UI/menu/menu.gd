extends CanvasLayer
@onready var configs = $Configs
@onready var opcoes = $Opcoes
@onready var video = $VideoStreamPlayer
var video_freed = 0
@onready var anim_player = $AnimationPlayer
@onready var inst = configs
@onready var music = $Musica

var state = 0

enum State {
	JOGAR,
	OPCOES,
	CREDITOS,
	SAIR
}




var SkipCount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configs.hide()
	opcoes.hide()
	video.play()
	await video.finished
	music.play()
	video.queue_free()
	opcoes.visible = true


func _enter_tree() -> void:
	#if Global.is_in_gaming:
		#music.play()
	pass

func _exit_tree() -> void:
	pass

func handle_page(index : int):
	for i in $Opcoes.get_children():
		i.visible = false
	match index:
		0:
			$Papel.frame_coords = Vector2i(0, 1)
			$Opcoes/Iniciar.visible = true

		1:
			$Papel.frame_coords = Vector2i(0, 4)
			$"Opcoes/Opções".visible = true
		2:
			$Papel.frame_coords = Vector2i(0, 3)
			$"Opcoes/Créditos".visible = true
		3:
			$Papel.frame_coords = Vector2i(0, 2)
			$Opcoes/Sair.visible = true
		4:
			$Papel.frame_coords = Vector2i(0, 5)
			$Opcoes/Extras.visible = true

func _process(_delta: float) -> void:
	skip_video()
	#handle_page()


func skip_video():
	if video:
		if video_freed != 1:
			if video.is_playing() and Input.is_action_just_pressed("ui_accept") and SkipCount == 1:
				video.speed_scale = 999
				video_freed = 1
			elif video.is_playing() and Input.is_action_just_pressed("ui_accept"):
				SkipCount = 1

func _on_button_pressed() -> void:
	music.stop()
	if Global.is_in_gaming == false:
		await SceneTransition.play(SceneTransition.Transition.SHARP_IN)
		get_node("/root/").add_child(Global.gameworld)
		get_node("/root/").add_child(Global.escMenu)
		Global.is_in_gaming = true
		Global.menuInicio = get_node(".")
		SceneTransition.play(SceneTransition.Transition.SHARP_OUT)
		get_tree().root.remove_child(self)
	else:
		await SceneTransition.play(SceneTransition.Transition.SHARP_IN)
		get_node("/root/").add_child(Global.gameworld)
		SceneTransition.play(SceneTransition.Transition.SHARP_OUT)
		get_node("/root/").add_child(Global.escMenu)
		get_tree().root.remove_child(self)
		


func _on_button_2_pressed() -> void:
	add_child(configs)
	opcoes.hide()
	$Setas.visible = false
	configs.visible = 1
	await child_exiting_tree
	opcoes.visible = 1
	$Setas.visible = true
	configs.hide()


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_botão_da_direita_pressed() -> void:
	var temp = state + 1
	state = clamp(temp,-1,5)
	if state == 5:
		state = 0
	handle_page(state)

func _on_botão_da_esquerda_pressed() -> void:
	var temp = state - 1
	state = clamp(temp,-1,5)
	if state == -1:
		state = 4
	handle_page(state)


func _on_extras_pressed() -> void:
	pass # Replace with function body.
