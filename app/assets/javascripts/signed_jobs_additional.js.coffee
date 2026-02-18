window.crm ||= {}
window.crm.add_additional_expense = ->
  container = $('#additional_expenses_container')
  count = container.find('.additional-expense-row:visible').length
  if count < 20
    template = $('#additional_expense_template tbody').html()
    new_id = new Date().getTime()
    regexp = new RegExp('new_additional_expenses', 'g')
    container.append(template.replace(regexp, new_id))

    # Hide button if we reached the limit
    if container.find('.additional-expense-row:visible').length >= 20
      $('#add_expense_button').hide()
  else
    alert('Maximum 20 additional expenses allowed')
