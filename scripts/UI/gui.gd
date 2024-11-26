extends CanvasLayer

const LIFE_BAR_SIZE = 8
const BAR_OFFSET = 16


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$coin_number.text = var_to_str(player_data.coin)
