# gtmk-jam-26
https://docs.google.com/document/d/1D3CSHR3VM4PiIvGKUp8vCMKTD334qvU53O2-uIfZszw/edit?usp=sharing

Explaination On Globals:
	Signals : Main is the only thing that listen to signals and is a way to communicate scene changes as well as important shared
	logic. Lets us build the three phases in parallel currently, and is a way to share information between the three phases

	Gamemanager: holds reference nodes so that we dont need a hardcoded preload path that way we dont need transition logic in 
	each phase script

	StateMachine: holds current state and each phase is registered with an on_enter and on_exit, if for example Hunt or Butcher need its own sub-states , 
	you can use a nested statemachine inside the Hunt or Butcher scene rather than this general one that is in Main

	RunManager: Holds information on money and how many hunts youve been on. 
	
	EquipmentManager - Holds information on what the player has already and how much of each item they have. 
	
	ShopCatalog - Holds data only so that it can be read by the equipment shop, so that it is not hardcoded in Shop Scene
	
	 
