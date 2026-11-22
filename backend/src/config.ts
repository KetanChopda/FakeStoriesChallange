import envSchema from 'env-schema'
import { Type, type Static } from '@sinclair/typebox'

const schema = Type.Object({
  PORT: Type.Number({ default: 3000 }),
  HOST: Type.String({ default: '0.0.0.0' }),
  LOG_LEVEL: Type.Union([
    Type.Literal('trace'),
    Type.Literal('debug'),
    Type.Literal('info'),
    Type.Literal('warn'),
    Type.Literal('error'),
    Type.Literal('fatal')
  ], { default: 'info' }),
  FAKE_STORE_BASE_URL: Type.String({ default: 'https://fakestoreapi.com' }),
  FAKE_STORE_TIMEOUT_MS: Type.Number({ default: 5000 }),
  CATALOGUE_CACHE_SECONDS: Type.Number({ default: 300 }),
  SMTP_HOST: Type.String({ default: '127.0.0.1' }),
  SMTP_PORT: Type.Number({ default: 1025 }),
  SMTP_SECURE: Type.Boolean({ default: false }),
  SMTP_USER: Type.String({ default: '' }),
  SMTP_PASSWORD: Type.String({ default: '' }),
  MAIL_FROM: Type.String({ default: 'Catalogue <no-reply@example.com>' }),
  SALES_INBOX: Type.String({ default: 'sales@example.com' })
})

export type Config = Static<typeof schema>

/** Reads and validates environment variables (and .env) once at startup. */
export function loadConfig (): Config {
  return envSchema<Config>({ schema, dotenv: true })
}
