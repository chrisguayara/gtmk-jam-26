extends Node

var _catalogs: Dictionary = {} 

func register_catalog(shop_id: StringName, items: Array) -> void:
	_catalogs[shop_id] = items

func get_catalog(shop_id: StringName) -> Array:
	return _catalogs.get(shop_id, [])
