document.addEventListener('turbolinks:load', () => {

  const fileField = document.getElementById('user_image')
  const popupMenu = document.querySelector('.popup-menu');
  const overlay = document.querySelector('.overlay');
  const cancelButton = document.querySelector('.cancel')
  document.querySelector(".my_image").addEventListener('click', function() {
    popupMenu.classList.remove('hidden');
    overlay.classList.remove('hidden');
    document.querySelector('.upload-image').addEventListener('click', () => {
      fileField.click()
    });
  });
  
  const hidePopup = () => {
    popupMenu.classList.add('hidden');
    overlay.classList.add('hidden');
  };
  overlay.addEventListener('click', hidePopup);
  cancelButton.addEventListener('click', hidePopup);

  $('input[type=file]').on('change', function(e) {
    if (e.target.files[0].size > 0) {
      $(this).parents('form').trigger('submit');
      hidePopup;
    };
  });

});