extends Area2D
@export var new_level : String = "res://data/levels/level_boss.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Character) -> void:
	if body == Global.player:
		get_parent().get_parent().emit_signal("change_level", new_level)
