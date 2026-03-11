extends Character

var last_atk
var countLimit = 0
var save_attack

enum Attacks {
	IDLE,
	ESTOCADA,
	LEVANTANDO,
	ESPINHO,
	PENTE,
	MORDIDA
}

var dict = {
	"Estocada" : Attacks.ESTOCADA,
	"Pente" : Attacks.PENTE,
	"Mordida" : Attacks.MORDIDA
	
}

var ordem_ataques : Array = ["Estocada", "Pente", "Mordida"];
var state_atk : Attacks = Attacks.IDLE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	$"Damage Emitter".area_entered.connect(giving_dmg)
	$"Damage Receiver".dmg_taked.connect(taking_dmg.bind())
	$Timer.start()


func take_attack(attack : Attacks):
	print("atk removido: " + str(attack))
	match attack:
		Attacks.ESTOCADA:
			ordem_ataques.erase("Estocada")
			save_attack = "Estocada"
		Attacks.MORDIDA:
			ordem_ataques.erase("Mordida")
			save_attack = "Mordida"
		Attacks.PENTE:
			ordem_ataques.erase("Pente")
			save_attack = "Pente"
			


func restore_attack():
	ordem_ataques.push_back(save_attack)

func taking_dmg(dmgReceived : int, _direction):
	health -= dmgReceived
	print(health)
	if health <= 0:
		state = State.DEATH
		await $AnimationTree.animation_finished
		Global.final_signal.emit()
		get_parent().music.playing = false
		queue_free()
		
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	#print("oi")
	var atk = ordem_ataques.pick_random()
	state_atk = dict[atk]
	
	if state_atk == last_atk:
		countLimit += 1
	else:
		countLimit = 0
	
	if countLimit == 1:
		take_attack(last_atk)
		print(ordem_ataques)
		$cooldown.start()
		countLimit = 0
	
	last_atk = state_atk
	
	$Timer.paused = true
	await $AnimationTree.animation_finished
	#print("pausa")
	$Timer.paused = false
	
	

func on_attack_complete():
	if state_atk == Attacks.ESTOCADA:
		var random = [1,2].pick_random()
		match random:
			2:
				state_atk = Attacks.ESPINHO
			_:
				state_atk = Attacks.LEVANTANDO

	
	else:
		state_atk = Attacks.IDLE


func _on_cooldown_timeout() -> void:
	restore_attack()
	$cooldown.stop()
