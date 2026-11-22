import { buildApp } from './app.ts'
import { loadConfig } from './config.ts'

const config = loadConfig()
const app = buildApp(config)

/** Closes open connections before exiting, so container stops are clean. */
async function shutdown (signal: NodeJS.Signals): Promise<void> {
  app.log.info({ signal }, 'shutting down')
  await app.close()
  process.exit(0)
}

process.on('SIGTERM', () => shutdown('SIGTERM'))
process.on('SIGINT', () => shutdown('SIGINT'))

await app.listen({ port: config.PORT, host: config.HOST })
