extends Level
@onready var music = $music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	Global.player.position = spawnpoint.position
	Global.camera.limit_bottom = 180
	Global.camera.limit_right = 360
	Global.camera.zoom = Vector2(1.7,1.7)
	get_parent().change_music(music)
	remove_child(music)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
