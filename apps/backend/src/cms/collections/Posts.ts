import type { CollectionConfig } from 'payload'
import { anyAdminAccess, anyAdminOrSignedInAccess } from '../access'
import { Collection } from '../types'
import { getDefaultEditor } from '../editor'

export const Posts: CollectionConfig = {
  slug: Collection.Posts,
  labels: {
    singular: {
      en: 'Post',
      uk: 'Пост',
    },
    plural: {
      en: 'Posts',
      uk: 'Пости',
    },
  },
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
      label: {
        en: 'Title',
        uk: 'Заголовок',
      },
      required: true,
      localized: true,
    },
    {
      name: 'media',
      type: 'upload',
      label: {
        en: 'Media',
        uk: 'Медіа',
      },
      relationTo: Collection.Media,
      required: true,
    },
    {
      name: 'content',
      type: 'richText',
      label: {
        en: 'Content',
        uk: 'Контент',
      },
      editor: getDefaultEditor(),
      required: true,
      localized: true,
    },
  ],
}
