import type { CollectionConfig } from 'payload'
import { anyAdminAccess, anyAdminOrSignedInAccess } from '../access'

export const Pages: CollectionConfig = {
  slug: 'pages',
  admin: {
    useAsTitle: 'title',
  },
  access: {
    read: anyAdminOrSignedInAccess,
    create: anyAdminAccess,
    update: anyAdminAccess,
    delete: anyAdminAccess,
  },
  fields: [
    {
      name: 'title',
      type: 'text',
      required: true,
    },
    {
      name: 'media',
      type: 'upload',
      relationTo: 'media',
      required: true,
    },
  ],
}
