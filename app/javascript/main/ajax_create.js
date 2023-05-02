import { event } from "jquery";

document.addEventListener('turbolinks:load', () => {
  const form = document.querySelector("#hidden-form");
  // eventには、イベントが発生した要素や座標が含まれている。
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const url = form.getAttribute('action');
    const method = form.getAttribute('method');
    const formDate = new FormData(form)

    // Webリソースの取得や送信を行うためのJavaScriptのインターフェース
    fetch(url, {
      method: method,
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
      },
      body: formDate
    })
    // レスポンスを処理するためのコード
    .then(response => {
      if (response.ok) {
        // dataにはcreate.js処理後の完全なHTMLが含まれている。
        response.text().then(data => {
          // dataを全て表示するのではなく、一部のみを更新する
          const addTask = $(data).filter(".task-field").html()
          $(".task-field").append();
          $("#task_title").val("");
          $("#flash-messages").html('');
        })
      } else {
        throw new Error('Network response was not ok')
      }
    })
    // エラーを処理するためのコード
    .catch(error => {
      
    })
  })
})