// Load the webcomponentsjs polyfill
require('script!../bower_components/webcomponentsjs/webcomponents.js')

window.Polymer = {
  dom: 'shadow',
  lazyRegister: true,
  useNativeCSSProperties: true,
}

// Require your main webcomponent file (that can be just a file filled with html imports, custom styles or whatever)
require('vulcanize?es6=false&base=./!./imports.html')

// Require our styles
require('./main.css')

window.addEventListener('WebComponentsReady', () => {
  let Elm = require('./Main.elm')
  let root = document.getElementById('root')
  let app = Elm.Main.embed(root)

  app.ports.closeDrawer.subscribe(() => {
    if(!getAppDrawer().persistent){
      getAppDrawer().close()
    }
  })

  // Set our stripe publishable key - yours will be different!
  Stripe.setPublishableKey('pk_test_ui9kge72Kvk3KHQnRYoRSPYf')
  app.ports.askForToken.subscribe((creditCardModel) => {
    Stripe.card.createToken({
      number: creditCardModel.ccNumber,
      cvc: creditCardModel.cvc,
      exp: creditCardModel.expiration,
      address_zip: creditCardModel.zip,
    }, stripeResponseHandler)
  })

  function stripeResponseHandler(status, response){
    console.log("got stripe data back!")
    console.log("status", status)
    console.log("response", response)
    app.ports.receiveToken.send(response.id)
  }

  function getAppDrawerLayout() {
    return document.getElementsByTagName('app-drawer-layout')[0]
  }

  function getAppDrawer() {
    return getAppDrawerLayout().drawer
  }
})
