extends Character

var detect_player = 0

func taking_dmg(dmgReceived : int, _direction):
	health -= dmgReceived
	
	print("receba")
	if health <= 0:
		queue_free()
	else:
		Global.player.velocity.y = -300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_actions(_delta : float):
	var direction = Global.player.position.x - position.x
	if Global.player != null:
		if can_move():
			velocity.x = clamp(direction,  -1 * SPEED, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)



# Animation
func handle_flip():
	if can_act():
		if velocity.x < 0:
			sprite.flip_h = true
			$"Attack stuffs".scale.x = -1
			$"Damage Emitter".scale.x = -1
			
		elif velocity.x > 0:
			sprite.flip_h = false
			$"Attack stuffs".scale.x = 1
			$"Damage Emitter".scale.x = 1

func on_animation_complete():
	if health <= 0:
		state = State.DEATH
	else:
		state = State.IDLE

func _on_detect_area_body_entered(body: Node2D) -> void:
	if body:
		print(body)
		state = State.ATTACK

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	#print(state)
