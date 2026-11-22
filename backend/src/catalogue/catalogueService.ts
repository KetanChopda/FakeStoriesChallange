import { productNotFound } from '../errors.ts'
import { createTtlCache } from './cache.ts'
import type { Product } from './product.ts'

export interface CatalogueService {
  products: () => Promise<Product[]>
  product: (id: number) => Promise<Product>
  categories: () => Promise<string[]>
}

export interface CatalogueOptions {
  fetchProducts: () => Promise<Product[]>
  cacheTtlMs: number
}

/** The catalogue read side: all products are loaded through one cache; lookups happen in memory. */
export function createCatalogueService (options: CatalogueOptions): CatalogueService {
  const cache = createTtlCache(options.fetchProducts, options.cacheTtlMs)

  return {
    products: () => cache.get(),

    async product (id) {
      const found = (await cache.get()).find((product) => product.id === id)
      if (found === undefined) {
        throw productNotFound(id)
      }
      return found
    },

    async categories () {
      const names = new Set((await cache.get()).map((product) => product.category))
      return [...names].sort()
    }
  }
}
