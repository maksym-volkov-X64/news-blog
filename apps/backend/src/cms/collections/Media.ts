import type { CollectionConfig } from 'payload'
import { anyAdminAccess, anyAdminOrSignedInAccess } from '../access'
import { Collection } from '../types'

export const defaultPhotoMimeTypes = [
  'image/jpeg',
  'image/jp2',
  'image/jpx',
  'image/jpm',
  'image/jxr',
  'image/jxl',
  'image/png',
  'image/tiff',
  'image/webp',
  'image/avif',
]

export const defaultVideoMimeTypes = [
  'video/avi',
  'video/mp4',
  'video/mpeg',
  'video/ogg',
  'video/webm',
]
export const defaultGraphicsMimeTypes = [...defaultPhotoMimeTypes, 'video/webm', 'image/svg+xml']
export const flavoursMediaMimeTypes = [...defaultPhotoMimeTypes, 'image/svg+xml']
export const productMediaMimeTypes = [...defaultGraphicsMimeTypes, 'video/webm']

export const Media: CollectionConfig = {
  slug: Collection.Media,
  labels: {
    singular: {
      en: 'Media',
      uk: 'Медіа',
    },
    plural: {
      en: 'Media',
      uk: 'Медіа',
    },
  },
  access: {
    read: anyAdminOrSignedInAccess,
    create: anyAdminAccess,
    update: anyAdminAccess,
    delete: anyAdminAccess,
  },
  upload: {
    mimeTypes: [...defaultGraphicsMimeTypes, 'application/pdf', 'image/gif'],
    imageSizes: [
      {
        name: 'size_768',
        width: 768,
        formatOptions: { format: 'webp', options: { quality: 85 } },
      },
      {
        name: 'size_1024',
        width: 1024,
        formatOptions: { format: 'webp', options: { quality: 85 } },
      },
      {
        name: 'size_1280',
        width: 1280,
        formatOptions: { format: 'webp', options: { quality: 85 } },
      },
      {
        name: 'size_1440',
        width: 1400,
        formatOptions: { format: 'webp', options: { quality: 85 } },
      },
      {
        name: 'size_1920',
        width: 1920,
        formatOptions: { format: 'webp', options: { quality: 85 } },
      },
      {
        name: 'size_2560',
        width: 2560,
        formatOptions: { format: 'webp', options: { quality: 85 } },
      },
    ],
  },
  fields: [
    {
      name: 'alt',
      type: 'text',
      required: true,
    },
  ],
}
