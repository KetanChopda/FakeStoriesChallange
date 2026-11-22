import type { FastifyInstance } from 'fastify'
import { AppError } from '../errors.ts'

function isValidationError (error: unknown): error is Error {
  return error instanceof Error && 'validation' in error && error.validation !== undefined
}

/** Gives every error the same JSON shape: { error: { code, message } }. */
export function registerErrorHandling (app: FastifyInstance): void {
  app.setErrorHandler((error: unknown, request, reply) => {
    if (error instanceof AppError) {
      return reply.status(error.statusCode).send({ error: { code: error.code, message: error.message } })
    }
    if (isValidationError(error)) {
      return reply.status(400).send({ error: { code: 'invalid_request', message: error.message } })
    }
    request.log.error({ err: error }, 'unhandled error')
    return reply.status(500).send({ error: { code: 'internal_error', message: 'Something went wrong on our side.' } })
  })

  app.setNotFoundHandler((request, reply) => {
    reply.status(404).send({ error: { code: 'not_found', message: `No route for ${request.method} ${request.url}.` } })
  })
}
