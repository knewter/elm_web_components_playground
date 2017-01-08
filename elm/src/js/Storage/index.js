const storageKeys = {
  apiKey: 'ELM_WEB_COMPONENTS_API_KEY'
}

export default {
  set: (key, val) => {
    if(storageKeys.hasOwnProperty(key)){
      localStorage.setItem(storageKeys[key], val)
    } else {
      throw `No such storage key: ${key}`
    }
  },

  get: (key) => {
    return localStorage.getItem(storageKeys[key])
  }
}
