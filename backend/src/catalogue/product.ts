import { Type, type Static } from '@sinclair/typebox'

/** Product shape the iOS client reads; the same fields as the app's Product model. */
export const RatingSchema = Type.Object({
  rate: Type.Number(),
  count: Type.Integer()
})

export const ProductSchema = Type.Object({
  id: Type.Integer(),
  title: Type.String(),
  price: Type.Number(),
  description: Type.String(),
  category: Type.String(),
  image: Type.String(),
  rating: RatingSchema
})

export type Product = Static<typeof ProductSchema>
