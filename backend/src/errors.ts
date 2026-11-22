/** An error the API can explain to a client; carries the HTTP status and a stable machine-readable code. */
export class AppError extends Error {
  readonly statusCode: number
  readonly code: string

  constructor (statusCode: number, code: string, message: string) {
    super(message)
    this.statusCode = statusCode
    this.code = code
  }
}

export function productNotFound (id: number): AppError {
  return new AppError(404, 'product_not_found', `No product with id ${id}.`)
}

export function catalogueUnavailable (): AppError {
  return new AppError(502, 'catalogue_unavailable', 'The product catalogue is unavailable right now. Please try again shortly.')
}
