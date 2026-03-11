extends Node
@onready var gameworld : Node = preload("res://data/elements/gameworld.tscn").instantiate()
@onready var escMenu : Node = preload("res://data/UI/menu/esc_menu.tscn").instantiate()
@onready var final  = preload("res://data/final.tscn").instantiate()
var menuInicio : Node;
var player : CharacterBody2D
var camera : Camera2D

var is_in_gaming : bool = false

signal atores (player : CharacterBody2D, camera : Camera2D)
signal final_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	atores.connect(handle_actors)
	final_signal.connect(final_c)
	#get_tree().root.content_scale_size = Vector2i(640, 360)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func handle_actors(ply, cam):
	player = ply
	camera = cam

func voltar_ao_menu():
	await SceneTransition.play(SceneTransition.Transition.FADE_IN)
	SceneTransition.play(SceneTransition.Transition.FADE_OUT)
	get_tree().root.remove_child(gameworld)
	get_tree().root.add_child(menuInicio)
	await get_tree().create_timer(0.01).timeout
	menuInicio.music.play()
	
func final_c():
	get_tree().root.add_child(final)
	final.play()
	
