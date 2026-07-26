extends Node2D
class_name MusicManager
# Lives on Main, persists across every screen swap. play_track() is a no-op
# if the requested track is already playing -- that's what makes music
# "stay consistent" across ShoppingCenter/InShop/Butchering instead of
# restarting every time the player walks through a door.

@onready var main_menu_track: AudioStreamPlayer = $mainmenu
@onready var hunting_track: AudioStreamPlayer = $hunting
@onready var shopping_track: AudioStreamPlayer = $shopping

var _tracks: Dictionary = {}
var _current_track_id: StringName = &""

func _ready() -> void:
	_tracks = {
		&"main_menu": main_menu_track,
		&"hunting": hunting_track,
		&"shopping": shopping_track,
	}
	for player in _tracks.values():
		player.stop()

func play_track(track_id: StringName) -> void:
	if track_id == _current_track_id:
		return 
	if _tracks.has(_current_track_id):
		_tracks[_current_track_id].stop()
	_current_track_id = track_id
	if _tracks.has(track_id):
		_tracks[track_id].play()
