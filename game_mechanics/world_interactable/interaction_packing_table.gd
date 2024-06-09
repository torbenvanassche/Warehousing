extends Interaction

func execute(_dict: Dictionary = {}):
	UserInterface.instance.enable_ui(UserInterface.instance.get_subwindow("BOX_FITTING"), true, { carryable = Carryable.new(Vector2i(3, 3)) })
