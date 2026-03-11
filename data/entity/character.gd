class_name Character
extends CharacterBody2D

@export_group("👊 Atributos")
@export var max_health : int = 20
@export var damage : int = 3
@export var SPEED : float = 225

@export_group("🎦 Animações")
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer

var health : float


const JUMP_VELOCITY = -400.0
var jump_acc = JUMP_VELOCITY
var velAnterior = Vector2.ZERO

enum State{
	IDLE,
	WALK,
	JUMPING,
	JUMP,
	LAND,
	HURT,
	ATTACK,
	DEATH,
	CUSTOM
}

var state = State.IDLE

func _ready() -> void:
	health = max_health
	$"Damage Emitter".area_entered.connect(giving_dmg)
	$"Damage Receiver".dmg_taked.connect(taking_dmg.bind())


func air_time(_delta):
	if state == State.JUMP:
		lerp(velAnterior.y, velocity.y, 0.1)
		if is_on_floor_only() and velocity.y == 0:
			state = State.LAND

func handle_actions(_delta : float):
	pass


func _physics_process(delta: float) -> void:
	gravity(delta)
	air_time(delta)
	handle_actions(delta)
	handle_flip()
	handle_state()
	move_and_slide()
	
	velAnterior = velocity

func gravity(delta : float):
	# Add the gravity.
	if not is_on_floor_only():
		velocity += get_gravity() * delta


func taking_dmg(dmgReceived : int, _direction):
	health -= dmgReceived
	state = State.HURT
	
	#await anim_player.animation_finished
	if health <= 0:
		state = State.DEATH
		queue_free()
	pass
	

func giving_dmg(body : Area2D):
	body.dmg_taked.emit(damage, global_position.x)
	print("dano")


# State
func can_act(): return state == State.IDLE or state == State.WALK or state == State.JUMP
func can_move(): return state == State.IDLE or state == State.WALK
func can_attack(): return state == State.IDLE or state == State.WALK
func can_jump(): return state == State.IDLE or state == State.WALK

func handle_state():
	if state != State.DEATH:
		if can_move() and velocity.length() == 0:
			state = State.IDLE
		if can_move() and velocity.length() > 0:
			state = State.WALK 
		


# Animations
func on_jumping_complete():
	state = State.JUMP
	velocity.y = JUMP_VELOCITY


func on_animation_complete():
	state = State.IDLE

func on_hurting_complete():
	if health <= 0:
		state = State.DEATH
	else:
		state = State.IDLE

func handle_flip():
	if velocity.x < 0:
		sprite.flip_h = true
		$"Damage Emitter".scale.x = -1
	elif velocity.x > 0:
		sprite.flip_h = false
		$"Damage Emitter".scale.x = 1
