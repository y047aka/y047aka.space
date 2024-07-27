import devServer from '@hono/vite-dev-server'
import ssg from '@hono/vite-ssg'
import { defineConfig } from 'vite'

const entry = 'src/index.tsx'

export default defineConfig(() => {
  return {
    plugins: [devServer({ entry }), ssg({ entry })]
  }
})
