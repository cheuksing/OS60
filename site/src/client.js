import { app } from 'hyperapp'
import appConfig from './app'

const render = () =>
  app({
    ...appConfig,
    node: document.getElementById('app'),
  })

const isLoaded = new Promise((resolve) => {
  window.addEventListener('load', resolve)
})

isLoaded.then(render)
