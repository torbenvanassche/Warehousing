extends Interaction

func execute(_dict: Dictionary = {}):
	UIManager.enable_ui(UIManager.get_subwindow("PUZZLE"))
