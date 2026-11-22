import { AppError } from '../errors.ts'
import type { CatalogueService } from '../catalogue/catalogueService.ts'
import type { Mailer } from '../mail/mailer.ts'
import type { EnquiryInput } from './enquiry.ts'

export interface EnquiryService {
  submit: (input: EnquiryInput) => Promise<void>
}

export interface EnquiryDependencies {
  catalogue: CatalogueService
  mailer: Mailer
  salesInbox: string
  mailFrom: string
}

/** Checks the product exists, then emails the enquiry to the sales inbox. */
export function createEnquiryService (deps: EnquiryDependencies): EnquiryService {
  return {
    async submit (input) {
      const product = await deps.catalogue.product(input.productId)

      const lines = [
        `Product: ${product.title} (id ${product.id})`,
        `Name: ${input.name}`,
        `Email: ${input.email}`,
        `Phone: ${input.phone ?? 'not given'}`,
        '',
        input.message
      ]

      try {
        await deps.mailer.send({
          to: deps.salesInbox,
          from: deps.mailFrom,
          replyTo: input.email,
          subject: `New enquiry about product ${product.id}`,
          text: lines.join('\n')
        })
      } catch {
        throw new AppError(502, 'enquiry_not_sent', 'We could not send your enquiry. Please try again shortly.')
      }
    }
  }
}
