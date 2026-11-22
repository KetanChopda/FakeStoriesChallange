import Fastify, { type FastifyInstance } from 'fastify'
import { createCatalogueService } from './catalogue/catalogueService.ts'
import { createFakeStoreClient } from './catalogue/fakeStoreClient.ts'
import { registerCatalogueRoutes } from './catalogue/routes.ts'
import type { Config } from './config.ts'
import { registerErrorHandling } from './http/errorHandler.ts'

/** Builds the HTTP app without starting it, so the server entry point stays small. */
export function buildApp (config: Config): FastifyInstance {
  const app = Fastify({ logger: { level: config.LOG_LEVEL } })

  const fakeStore = createFakeStoreClient({
    baseUrl: config.FAKE_STORE_BASE_URL,
    timeoutMs: config.FAKE_STORE_TIMEOUT_MS
  })
  const catalogue = createCatalogueService({
    fetchProducts: fakeStore.fetchProducts,
    cacheTtlMs: config.CATALOGUE_CACHE_SECONDS * 1000
  })

  registerErrorHandling(app)
  app.get('/health', async () => ({ status: 'ok' }))
  registerCatalogueRoutes(app, catalogue)

  return app
}
