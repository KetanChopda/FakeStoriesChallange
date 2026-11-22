/**
 * Keeps one loaded value for a time. Concurrent callers share a single in-flight load,
 * so a burst of requests hits Fake Store once.
 */
export function createTtlCache<T> (load: () => Promise<T>, ttlMs: number): { get: () => Promise<T> } {
  let stored: { value: T, expiresAt: number } | undefined
  let inFlight: Promise<T> | undefined

  return {
    get () {
      if (stored !== undefined && stored.expiresAt > Date.now()) {
        return Promise.resolve(stored.value)
      }
      inFlight ??= load()
        .then((value) => {
          stored = { value, expiresAt: Date.now() + ttlMs }
          return value
        })
        .finally(() => {
          inFlight = undefined
        })
      return inFlight
    }
  }
}
