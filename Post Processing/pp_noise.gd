extends AddTexToIntRes

var noise : FastNoiseLite

func _ready() -> void:
	noise = (texture as NoiseTexture2D).noise

func _process(_delta: float) -> void:
	noise.seed = randi()
