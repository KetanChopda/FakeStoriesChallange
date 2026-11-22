import { Type } from '@sinclair/typebox'
import { Value } from '@sinclair/typebox/value'
import { catalogueUnavailable } from '../errors.ts'
import { ProductSchema, type Product } from './product.ts'

const ProductListSchema = Type.Array(ProductSchema)

export interface FakeStoreOptions {
  baseUrl: string
  timeoutMs: number
}

/** Fetches the full product list from Fake Store and checks its shape before anything uses it. */
export function createFakeStoreClient (options: FakeStoreOptions): { fetchProducts: () => Promise<Product[]> } {
  return {
    async fetchProducts () {
      const url = new URL('/products', options.baseUrl)
      let response: Response
      try {
        response = await fetch(url, { signal: AbortSignal.timeout(options.timeoutMs) })
      } catch {
        throw catalogueUnavailable()
      }
      if (!response.ok) {
        throw catalogueUnavailable()
      }
      try {
        return Value.Parse(ProductListSchema, await response.json())
      } catch {
        throw catalogueUnavailable()
      }
    }
  }
}
