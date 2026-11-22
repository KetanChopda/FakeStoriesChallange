import Fastify, { type FastifyInstance } from 'fastify'
import type { Config } from './config.ts'

/** Builds the HTTP app without starting it, so the server entry point stays small. */
export function buildApp (config: Config): FastifyInstance {
  const app = Fastify({ logger: { level: config.LOG_LEVEL } })

  app.get('/health', async () => ({ status: 'ok' }))

  return app
}
