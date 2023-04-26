$(document).on('click', '.add-task-form', function() {
  if ($('.edit-task').length > 0) {
    $(".edit-task").remove()
    $(".added-task").show()
  }
})