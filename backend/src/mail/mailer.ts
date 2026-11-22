/** What a sent message needs; the app depends on this shape, not on any mail library. */
export interface MailMessage {
  to: string
  from: string
  replyTo: string
  subject: string
  text: string
}

/** Sends one message. Implementations decide the transport (SMTP locally, SES later). */
export interface Mailer {
  send: (message: MailMessage) => Promise<void>
}
