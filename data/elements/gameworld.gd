extends Node2D
@onready var player = $Player 
@onready var camera = $Camera2D
@onready var healthBar = $CanvasLayer/HealthBar
@onready var player_death = preload("res://data/UI/death_screen.tscn").instantiate()
@onready var music : AudioStreamPlayer = $music
@export var start_level : String = "res://data/levels/level_1.tscn"
var level_atual = start_level

var level : Node2D = load(start_level).instantiate()

signal reload()
signal change_level(level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#level = load(start_level).instantiate()
	Global.atores.emit(player, camera)
	call_deferred("add_child", level)
	
	healthBar.max_value = player.max_health
	healthBar.value = player.max_health
	
	print(healthBar.max_value)
	
	reload.connect(reload_level)
	change_level.connect(change_lvl.bind())
	player.hurt.connect(update_player_life)
	player.death.connect(death_screen)
	
	update_player_life()
	
func _enter_tree() -> void:
	level = load(start_level).instantiate()
	call_deferred("add_child", level)

func _exit_tree() -> void:
	level.queue_free()
	
func reload_level():
	SceneTransition.play(SceneTransition.Transition.FADE_OUT)
	level.queue_free()
	
	level = load(level_atual).instantiate()
	player.revive()
	update_player_life()
	call_deferred("add_child", level)
	
func change_lvl(lvl : String):
	await SceneTransition.play(SceneTransition.Transition.FADE_IN)
	level_atual = lvl
	level.queue_free()
	level = load(lvl).instantiate()
	SceneTransition.play(SceneTransition.Transition.FADE_OUT)
	call_deferred("add_child",level)
	
	
func change_music(misc : AudioStreamPlayer):
	if music.stream != misc.stream:
		music.stream = misc.stream
		print(music)
		#music.set_loop(true)
		music.play()

func update_player_life():
	#print(player.health)
	healthBar.value = player.health
	
	

func death_screen():
	add_child(player_death)
	music.stream_paused = true
	await child_exiting_tree
	music.stream_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
