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
  ], { default: 'info' })
})

export type Config = Static<typeof schema>

/** Reads and validates environment variables (and .env) once at startup. */
export function loadConfig (): Config {
  return envSchema<Config>({ schema, dotenv: true })
}
