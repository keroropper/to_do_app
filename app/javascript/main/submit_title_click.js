document.addEventListener('turbolinks:load', () => {
  function submitTitle(event) {
    const taskTitle = event.target.textContent;
    const hiddenForm = document.querySelector("#hidden-form");
    const hiddenField = hiddenForm.querySelector("[name='task[title]']");
    hiddenField.value = taskTitle;
    hiddenForm.submit();
  }

  const taskTitleElements = document.querySelectorAll(".task-title");
  taskTitleElements.forEach(element => {
    element.addEventListener("click", submitTitle)
  })

})