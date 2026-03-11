extends Character
 
signal death
signal hurt

@onready var timer = $Timer
@onready var sfx = $sfx_hurt
@onready var sfx_hit = $sfx_hit

enum CoyoteState {
	TRUE,
	COOLDOWN,
	FALSE,
}
var in_coyote_time = CoyoteState.FALSE

var is_dead : bool = false
var is_stomping : bool = false




func air_time(_delta : float):
	if state == State.JUMP:
		#lerp(velAnterior.y, velocity.y, 0.1)
		# Pulo variávl
		if Input.is_action_just_released("jump") and velocity.y <= JUMP_VELOCITY/2:
			velocity.y *= 0.4
			
		if is_on_floor_only() and velocity.y == 0:
			state = State.LAND


# Handle stomp
func stomping(_delta):	
	if is_stomping and velocity.y >= -100:
		velocity.y *= 1.1
		if velocity.y == 0:
			state = State.IDLE
			is_stomping = false


func coyote_time():
	if timer.time_left != 0 and in_coyote_time == CoyoteState.TRUE:
		if Input.is_action_just_pressed("jump"):
			state = State.JUMPING
			in_coyote_time = CoyoteState.COOLDOWN


func handle_actions(_delta : float):
	var direction := Input.get_axis("ui_left", "ui_right")
	if can_act() and direction:
		if is_stomping:
			velocity.x = direction * SPEED * 0.5
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle jump.
	if can_jump() and Input.is_action_just_pressed("jump") and is_on_floor():
		state = State.JUMPING


	# Handle Attacks
	if can_stomp() and Input.is_action_just_pressed("attack"):
		state = State.CUSTOM
		is_stomping = true



func taking_dmg(dmgReceived : int, direction):
	if state == State.HURT:
		pass
	else:
		health -= dmgReceived
		hurt.emit()
		state = State.HURT
		sfx.play()
		velocity.x = -3 * SPEED if global_position.x < direction else 3 * SPEED
		velocity.y = JUMP_VELOCITY/3
		
		await $AnimationTree.animation_finished
		if health <= 0:
			is_dead = true
			emit_signal("death")

func giving_dmg(body : Area2D):
	body.dmg_taked.emit(damage, global_position.x)
	sfx_hit.play()


func revive():
	health = max_health
	state = State.IDLE
	is_dead = 0

# State
func can_stomp(): return state == State.JUMP
func can_act(): return state == State.IDLE or state == State.WALK or state == State.JUMP or is_stomping

# Animations
func handle_flip():
	if velocity.x < 0:
		sprite.flip_h = true
		$Marker2D.position.x = 17
	elif velocity.x > 0:
		sprite.flip_h = false
		$Marker2D.position.x = -17


func _on_area_2d_area_entered(_chao: Area2D) -> void:
	if in_coyote_time == CoyoteState.FALSE and not is_on_floor_only():
		timer.start()
		in_coyote_time = CoyoteState.TRUE
		await timer.timeout
		timer.stop()
 

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	coyote_time()
	stomping(delta)
	 
	#if state != State.IDLE:
		#print(state)
