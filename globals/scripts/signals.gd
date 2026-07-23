extends Node

signal main_ready

signal hunt_started
signal hunt_beast_caught(beast: Resource)
signal hunt_resource_depleted
signal hunt_round_complete

signal butcher_started
signal butcher_cut_made(cuts_remaining: int)
signal butcher_round_complete

signal shop_entered(shop_id: StringName)
signal shop_exited
signal item_purchased(item_id: StringName, cost: int)
signal item_sold(item_id: StringName, value: int)
signal wallet_changed(old_amount: int, new_amount: int)
