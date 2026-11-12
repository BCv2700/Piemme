import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { execSync } from 'child_process'

let version = 'dev'
try {
  version = execSync('git describe --tags --abbrev=0', {
    cwd: new URL('..', import.meta.url).pathname
  }).toString().trim()
} catch (_) {
  try {
    version = execSync('git rev-parse --short HEAD', {
      cwd: new URL('..', import.meta.url).pathname
    }).toString().trim()
  } catch (__) {}
}

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  define: {
    __APP_VERSION__: JSON.stringify(version),
  },
})
