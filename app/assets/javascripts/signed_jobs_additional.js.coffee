window.crm ||= {}
window.crm.add_additional_expense = ->
  container = $('#additional_expenses_container')
  count = container.find('.additional-expense-row:visible').length
  if count < 20
    template = $('#additional_expense_template').html()
    new_id = new Date().getTime()
    regexp = new RegExp('new_additional_expenses', 'g')
    container.append(template.replace(regexp, new_id))

    # Hide button if we reached the limit
    if container.find('.additional-expense-row:visible').length >= 20
      $('#add_expense_button').hide()
  else
    alert('Maximum 20 additional expenses allowed')

$(document).ready ->
  $(document).on 'change', '#signed_job_file_input', (e) ->
    file = e.target.files[0]
    errorContainer = $('#file_error_message')
    submitButton = $(this).closest('form').find('input[type="submit"]')

    if file
      # Validation
      allowedExtensions = /(\.pdf|\.doc|\.docx|\.jpg|\.jpeg|\.txt)$/i
      maxSize = 10 * 1024 * 1024 # 10MB

      errors = []

      if !allowedExtensions.exec(file.name)
        errors.push "Invalid file type. Allowed: pdf, doc, docx, jpg, jpeg, txt"

      if file.size > maxSize
        errors.push "File is too large. Max size is 10MB"

      if errors.length > 0
        errorContainer.text(errors.join('. ')).show()
        submitButton.prop('disabled', true).css('opacity', '0.5')
      else
        errorContainer.hide().text('')
        submitButton.prop('disabled', false).css('opacity', '1')
    else
      errorContainer.hide().text('')
      submitButton.prop('disabled', false).css('opacity', '1')
