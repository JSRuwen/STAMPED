extends CanvasLayer
var on = 0
var count = 0


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	request_ready()


func _ready() -> void:
	on = false
	tela()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print(on)
	if Input.is_anything_pressed() and on:
		get_parent().reload_level()
		get_parent().remove_child(self)
		
func tela():
	$Timer.start()
	$AnimationPlayer.play("fade_in")
	$AudioStreamPlayer.play()
	await $Timer.timeout
	$Timer.stop()
	on = true
