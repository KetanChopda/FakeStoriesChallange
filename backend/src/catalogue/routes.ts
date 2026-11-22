import { Type } from '@sinclair/typebox'
import type { FastifyInstance } from 'fastify'
import type { CatalogueService } from './catalogueService.ts'
import { ProductSchema } from './product.ts'

export function registerCatalogueRoutes (app: FastifyInstance, catalogue: CatalogueService): void {
  app.get('/products', {
    schema: { response: { 200: Type.Array(ProductSchema) } }
  }, async () => catalogue.products())

  app.get<{ Params: { id: number } }>('/products/:id', {
    schema: {
      params: Type.Object({ id: Type.Integer() }),
      response: { 200: ProductSchema }
    }
  }, async (request) => catalogue.product(request.params.id))

  app.get('/categories', {
    schema: { response: { 200: Type.Array(Type.String()) } }
  }, async () => catalogue.categories())
}
