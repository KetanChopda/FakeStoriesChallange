import nodemailer from 'nodemailer'
import type { Mailer } from './mailer.ts'

export interface SmtpOptions {
  host: string
  port: number
  secure: boolean
  user: string
  password: string
}

/** Mailer over SMTP. Locally this points at Mailpit; on AWS it points at SES's SMTP endpoint. */
export function createSmtpMailer (options: SmtpOptions): Mailer {
  const transport = nodemailer.createTransport({
    host: options.host,
    port: options.port,
    secure: options.secure,
    auth: options.user === '' ? undefined : { user: options.user, pass: options.password }
  })

  return {
    async send (message) {
      await transport.sendMail(message)
    }
  }
}
