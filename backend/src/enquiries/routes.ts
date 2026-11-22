import { Type } from '@sinclair/typebox'
import type { FastifyInstance } from 'fastify'
import type { EnquiryService } from './enquiryService.ts'
import { EnquirySchema, type EnquiryInput } from './enquiry.ts'

export function registerEnquiryRoutes (app: FastifyInstance, enquiries: EnquiryService): void {
  app.post<{ Body: EnquiryInput }>('/enquiries', {
    schema: {
      body: EnquirySchema,
      response: { 201: Type.Object({ status: Type.Literal('received') }) }
    }
  }, async (request, reply) => {
    await enquiries.submit(request.body)
    return reply.status(201).send({ status: 'received' })
  })
}
