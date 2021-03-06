const config = require('config')

// Load the webcomponentsjs polyfill
require('script!../bower_components/webcomponentsjs/webcomponents.js')

window.Polymer = {
  dom: 'shadow',
  lazyRegister: true,
  useNativeCSSProperties: true,
}

// Require your main webcomponent file (that can be just a file filled with html imports, custom styles or whatever)
require('vulcanize?es6=false&base=./!./imports.html')

import Storage from './js/Storage'

// Require our styles
require('./main.css')

window.addEventListener('WebComponentsReady', () => {
  let Elm = require('./Main.elm')
  let root = document.getElementById('root')
  let app = Elm.Main.embed(root)

  app.ports.closeDrawer.subscribe(() => {
    if(getAppDrawer()){
      if(!getAppDrawer().persistent){
        getAppDrawer().close()
      }
    }
  })

  app.ports.storeApiKey.subscribe((apiKey) => {
    console.log('storeApiKey', apiKey)
    Storage.set('apiKey', apiKey)
  })

  let storedApiKey = Storage.get('apiKey')
  if(storedApiKey){
    app.ports.receiveApiKey.send(storedApiKey)
  }

  // Set our stripe publishable key - yours will be different!
  Stripe.setPublishableKey(config.stripe.publishableKey)
  app.ports.askForStripeToken.subscribe((creditCardModel) => {
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
    app.ports.receiveStripeToken.send(response.id)
  }

  function getAppDrawerLayout() {
    return document.getElementsByTagName('app-drawer-layout')[0]
  }

  function getAppDrawer() {
    if(getAppDrawerLayout()){
      return getAppDrawerLayout().drawer
    }
  }
})
