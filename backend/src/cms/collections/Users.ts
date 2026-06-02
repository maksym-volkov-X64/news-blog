import type { CollectionConfig } from 'payload'

const isNotDev = process.env.NODE_ENV !== 'development'

export const Users: CollectionConfig = {
  slug: 'users',
  admin: {
    useAsTitle: 'email',
  },
  auth: {
    useAPIKey: true,
    lockTime: 60 * 60,
    maxLoginAttempts: 5,
    tokenExpiration: 60 * 60 * 24 * 7,
    cookies: {
      sameSite: 'Strict',
      secure: isNotDev,
      domain: process.env.NEXT_PUBLIC_CMS_COOKIES_DOMAIN,
    },
  },
  fields: [
    // Email added by default
    // Add more fields as needed
  ],
}
