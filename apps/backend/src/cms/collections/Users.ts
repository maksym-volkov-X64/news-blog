import type { CollectionConfig } from 'payload'
import { UserRole } from '../types'
import {
  anyAdminAccess,
  anyAdminFieldAccess,
  anyManagerAdminUIAccess,
  rootAccess,
  rootFieldAccess,
} from '../access'

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
  access: {
    admin: anyManagerAdminUIAccess,
    create: rootAccess,
    delete: rootAccess,
    read: anyAdminAccess,
    update: rootAccess,
  },
  fields: [
    {
      name: 'roles',
      label: {
        en: 'Roles',
        uk: 'Ролі',
      },
      type: 'select',
      hasMany: true,
      defaultValue: [UserRole.Customer],
      options: [
        {
          label: {
            en: 'Root admin',
            uk: 'Головний адміністратор',
          },
          value: UserRole.Root,
        },
        {
          label: {
            en: 'Admin',
            uk: 'Адміністратор',
          },
          value: UserRole.Admin,
        },
        {
          label: {
            en: 'Content Manager',
            uk: 'Менеджер контенту',
          },
          value: UserRole.ContentManager,
        },
        {
          label: {
            en: 'Customer',
            uk: 'Клієнт',
          },
          value: UserRole.Customer,
        },
      ],
      access: {
        read: anyAdminFieldAccess,
        create: rootFieldAccess,
        update: rootFieldAccess,
      },
    },
  ],
}
