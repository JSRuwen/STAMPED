extends Level

@onready var music = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Parallax2D/AnimatedSprite2D.play("default")
	Global.player.position = spawnpoint.position
	Global.camera.set_Limit(1280, 720)
	get_parent().change_music(music)
	call_deferred("remove_child",music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Character) -> void:
	if body == Global.player:
		print("oi")
		$Portal/AnimationPlayer.play("opening")
		await $Portal/AnimationPlayer.animation_finished
		$Portal/AnimationPlayer.play("idle")
