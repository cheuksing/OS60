const puppeteer = require('puppeteer')
const path = require('path')
const fs = require('fs')

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

async function prerender(url) {
  const browser = await puppeteer.launch({
    args: [
      '--disable-gpu',
      '--disable-dev-shm-usage',
      '--disable-setuid-sandbox',
      '--no-first-run',
      '--no-sandbox',
      '--no-zygote',
      '--single-process',
    ],
  })
  const page = await browser.newPage()

  await page.goto(`file:${path.resolve(__dirname, 'dist', 'index.html')}`, {
    waitUntil: 'domcontentloaded',
  })

  await sleep(3000)

  const html = await page.content()

  await browser.close()

  fs.mkdir(
    path.resolve(__dirname, 'dist', 'prerender'),
    { recursive: true },
    (err) => {
      if (err) throw err

      fs.writeFileSync(
        path.resolve(
          __dirname,
          'dist',
          'prerender',
          url === '/' ? 'index.html' : url.split('/')[1] + '.html'
        ),
        html
      )
    }
  )
}

const routes = ['/']

routes.forEach(prerender)
