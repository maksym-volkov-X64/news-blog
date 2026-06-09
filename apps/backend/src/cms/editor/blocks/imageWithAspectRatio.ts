import { Collection } from '@/cms/types'
import { Block } from 'payload'

export const imageWithAspectRatioBlock: Block = {
  slug: 'image-with-aspect-ratio',
  labels: {
    singular: {
      en: 'Image with aspect ratio',
      uk: 'Зображення з співвідношенням сторін',
    },
    plural: {
      en: 'Images with aspect ratio',
      uk: 'Зображення з співвідношенням сторін',
    },
  },
  fields: [
    {
      name: 'image',
      label: {
        en: 'Image',
        uk: 'Зображення',
      },
      type: 'upload',
      relationTo: Collection.Media,
      required: true,
    },
    {
      name: 'aspectRatio',
      label: {
        en: 'Aspect ratio',
        uk: 'Співвідношення сторін',
      },
      type: 'select',
      options: [
        {
          label: '1 / 1',
          value: '1/1',
        },
        {
          label: '4 / 3',
          value: '4/3',
        },
        {
          label: '16 / 9',
          value: '16/9',
        },
        {
          label: '2 / 3',
          value: '2/3',
        },
      ],
      defaultValue: '16/9',
      required: true,
    },
  ],
}
