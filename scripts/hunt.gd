extends Node2D
class_name Hunt

@export var tool_id: StringName = &"spear"
@export var quota: int = 3

var _animals_caught: int = 0

func _ready() -> void:
	Signals.hunt_started.emit()

func throw_tool() -> void:
	if not EquipmentManager.consume_item(tool_id, 1):
		Signals.hunt_resource_depleted.emit()
		_check_round_end()
		return


func _on_animal_caught(animal_data: Resource) -> void:
	_animals_caught += 1
	Signals.hunt_animal_caught.emit(animal_data)
	_check_round_end()

func _check_round_end() -> void:
	var out_of_tools : bool = EquipmentManager.get_count(tool_id) <= 0
	var quota_met := _animals_caught >= quota
	if out_of_tools or quota_met:
		Signals.hunt_round_complete.emit()
