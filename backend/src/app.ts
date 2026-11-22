import Fastify, { type FastifyInstance } from 'fastify'
import { createCatalogueService } from './catalogue/catalogueService.ts'
import { createFakeStoreClient } from './catalogue/fakeStoreClient.ts'
import { registerCatalogueRoutes } from './catalogue/routes.ts'
import { createEnquiryService } from './enquiries/enquiryService.ts'
import { registerEnquiryRoutes } from './enquiries/routes.ts'
import type { Config } from './config.ts'
import { registerErrorHandling } from './http/errorHandler.ts'
import { createSmtpMailer } from './mail/smtpMailer.ts'

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

  const mailer = createSmtpMailer({
    host: config.SMTP_HOST,
    port: config.SMTP_PORT,
    secure: config.SMTP_SECURE,
    user: config.SMTP_USER,
    password: config.SMTP_PASSWORD
  })
  const enquiries = createEnquiryService({
    catalogue,
    mailer,
    salesInbox: config.SALES_INBOX,
    mailFrom: config.MAIL_FROM
  })

  registerErrorHandling(app)
  app.get('/health', async () => ({ status: 'ok' }))
  registerCatalogueRoutes(app, catalogue)
  registerEnquiryRoutes(app, enquiries)

  return app
}
