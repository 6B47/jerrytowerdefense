extends Node2D
# This acts as a base Map scene. To make a new level,
# just create a scene inheriting this one and use the tilemap to design it.
# You can use the Terrains feature to draw paths which already 
# navigation set-up, then tweak the spawner, tower, camera, etc. to
# your needs.


const STARTING_MONEY := 5000

@onready var tower := $Tower as Objective
@onready var spawner := $Spawner as Spawner
@onready var camera := $Camera2D as Camera2D
@onready var tilemap := $TileMap as TileMap


func _ready() -> void:
	randomize()
	# initialize money
	Global.money = STARTING_MONEY
	# initialize camera
	var map_limits := tilemap.get_used_rect()
	var cell_size := tilemap.tile_set.tile_size
	camera.limit_left = int(map_limits.position.x) * cell_size.x
	camera.limit_top = int(map_limits.position.y) * cell_size.y
	camera.limit_right = int(map_limits.end.x) * cell_size.x
	camera.limit_bottom = int(map_limits.end.y) * cell_size.y
	# connect signals
	spawner.wave_started.connect(Callable(camera.hud, "_on_spawner_wave_started"))
	spawner.waves_finished.connect(Callable(camera.hud, "_on_spawner_waves_finished"))
	tower.health_changed.connect(Callable(camera.hud, "_on_tower_health_changed"))
	tower.destroyed.connect(Callable(camera.hud, "_on_tower_destroyed"))
	# initialize HUD parameters
	(camera.hud as Hud).initialize(tower.health)  # tower will have already been initialized
	# start spawning enemies
	spawner.initialize(tower.global_position, map_limits, cell_size)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		# if there's a turret actions UI visible, hide it
		if Global.turret_actions:
			Global.turret_actions.hide()
