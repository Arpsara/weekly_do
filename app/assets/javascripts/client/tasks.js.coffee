$ ->
  $('#task_category_id').material_select()
  # Change categories when changing projet_id
  $('#task_project_id').on('change', () ->
    project_id = $('#task_project_id').prop('value')

    # SELECT PROJECT IN INPUT (HOME)
    $('#task_project_id').val("#{project_id}")
    $('#task_project_id').material_select()
    $("#task_project_id option[value=#{project_id}]").attr('selected','selected')

    $.post({
      url: gon.project_categories_url,
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: { id: project_id }
      success: (data) ->
        new_options = ""
        new_options += "<option value=''></option>"
        for object in data['categories']
          name = object[0]
          value = object[1]
          new_options += "<option value=#{value}>#{name}</option>"

        $('#task_category_id').html(new_options)
        $('#task_category_id').material_select()

    })
  )
