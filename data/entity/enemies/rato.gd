extends Character

@onready var ponto_A = $a
@onready var ponto_B = $b
@onready var timer = $Timer
@export var tempo : float = 0


var direcao : int = -1
var posicaoAntiga = 0



func _ready() -> void:
	timer.wait_time = tempo
	super._ready()
	timer.start()

func handle_actions(_delta : float):
	if can_move():
		if direcao >= 0:
			velocity.x = direcao * SPEED
			#print("?")
		else:
			velocity.x = direcao * SPEED
		
func handle_flip():
	if velocity.x < 0:
		sprite.flip_h = false
		$"Damage Emitter".scale.x = -1
	elif velocity.x > 0:
		sprite.flip_h = true
		$"Damage Emitter".scale.x = 1
	
func taking_dmg(dmgReceived : int, _direction):
	health -= dmgReceived
	print(health)
	if health <= 0:
		state = State.DEATH
		
		await $AnimationTree.animation_finished
		queue_free()
	else:
		Global.player.velocity.y = -150

func _physics_process(delta: float) -> void:
	super._physics_process(delta)



func _on_timer_timeout() -> void:
	direcao *= -1
	#print("oi")
