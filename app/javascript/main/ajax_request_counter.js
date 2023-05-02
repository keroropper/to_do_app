class AjaxRequestCounter {

  // 静的メソッド(クラスをインスタンス化せずに直接呼び出せる)を定義
  static start() {  
    // 自分自身をインスタンス化
    const _this = new AjaxRequestCounter()
    // 初期化
    window.pendingRequestCount = 0
    // 'ajax:send'イベントが発生した時に自分自身を呼び出し(handleEventが呼び出される)
    document.addEventListener('ajax:send', _this)
    document.addEventListener('ajax:complete', _this)
  }

  // addEventListenerが発生すると自動的に自動的に呼び出され、引数として発生したイベントが渡される
  handleEvent(event) {
    // eventには複数指定する方法があり、今回は「type」を指定している
    switch(event.type) {
      case 'ajax:send':
        pendingRequestCount++
        break

      case 'ajax:complete':
        pendingRequestCount--
        break
    }
  }
}

// exportする際は、そのオブエクトがオブジェクトリテラルであることを示すために{}で囲む必要がある。
export { AjaxRequestCounter }