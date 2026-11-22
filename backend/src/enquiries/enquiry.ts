import { Type, type Static } from '@sinclair/typebox'

/** A plain email shape check; the sales team's mail client does the real delivery check. */
const EMAIL_PATTERN = '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'
const NON_BLANK = '\\S'

export const EnquirySchema = Type.Object({
  productId: Type.Integer({ minimum: 1 }),
  name: Type.String({ minLength: 1, maxLength: 200, pattern: NON_BLANK }),
  email: Type.String({ maxLength: 254, pattern: EMAIL_PATTERN }),
  phone: Type.Optional(Type.String({ maxLength: 50 })),
  message: Type.String({ minLength: 1, maxLength: 2000, pattern: NON_BLANK })
}, { additionalProperties: false })

export type EnquiryInput = Static<typeof EnquirySchema>
