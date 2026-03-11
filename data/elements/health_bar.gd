extends TextureProgressBar

var player = Global.player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.hurt.connect()
	update()


func update():
	value = player.health * 100 / player.max_health
