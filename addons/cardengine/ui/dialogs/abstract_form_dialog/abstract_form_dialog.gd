tool
extends WindowDialog

signal form_validated(form)

var _form_name: String = ""
var _manager: AbstractManager = null

# Has to be called in the inherited dialog
func setup(form_name: String, manager: AbstractManager):
	_form_name = form_name
	_manager = manager

# To be override
func _reset_form():
	pass

# To be override
func _extract_form() -> Dictionary:
	return {}

func _clear_errors():
	$MainLayout/ErrorText.hide()
	$MainLayout/ErrorText.text = ""
	
func _on_AbstractFormDialog_about_to_show():
	_clear_errors()
	_reset_form()
	
func _on_CancelButton_pressed():
	hide()

func _on_SubmitButton_pressed():
	_clear_errors()
	var form = _extract_form()
	var errors = _manager.validate_form(_form_name, form)
	
	if errors.size() == 0:
		emit_signal("form_validated", form)
		hide()
	else:
		for err in errors:
			$MainLayout/ErrorText.text += err + "\n"
		$MainLayout/ErrorText.show()
