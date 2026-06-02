import { postgresAdapter } from '@payloadcms/db-postgres'
import { lexicalEditor } from '@payloadcms/richtext-lexical'
import path from 'path'
import { fileURLToPath } from 'url'
import sharp from 'sharp'

import { Users } from './src/cms/collections/Users'
import { Media } from './src/cms/collections/Media'
import { buildConfig, CollectionConfig, Config, ImageSize } from 'payload'
import { nodemailerAdapter } from '@payloadcms/email-nodemailer'
import { s3Storage } from '@payloadcms/storage-s3'
import { Pages } from '@/cms/collections/pages'

type GenerateFileURL = (args: {
  collection: CollectionConfig
  filename: string
  prefix?: string
  size?: ImageSize
}) => Promise<string> | string

const filename = fileURLToPath(import.meta.url)
const dirname = path.dirname(filename)

export const generatePublicFileURL: GenerateFileURL = ({ prefix, filename }) =>
  `${process.env.NEXT_PUBLIC_CDN_URL}/${process.env.S3_BUCKET_NAME}/${(prefix ? `${prefix}/` : '') + filename}`

const payloadConfig: Config = {
  admin: {
    user: Users.slug,
    importMap: {
      baseDir: path.resolve(dirname),
    },
  },
  cookiePrefix: 'news-blog',
  cors: [process.env.NEXT_PUBLIC_SITE_URL || ''].filter(Boolean),
  csrf: [process.env.NEXT_PUBLIC_SITE_URL || ''].filter(Boolean),
  collections: [Users, Media, Pages],
  editor: lexicalEditor(),
  secret: process.env.PAYLOAD_SECRET || '',
  typescript: {
    outputFile: path.resolve(dirname, 'src', 'cms', 'types', 'generated-types.ts'),
  },
  db: postgresAdapter({
    pool: {
      connectionString: process.env.DATABASE_URL || '',
    },
    migrationDir: path.resolve(dirname, 'src', 'cms', 'migrations'),
    // prodMigrations: migrations,
  }),
  email: nodemailerAdapter({
    defaultFromAddress: 'notifications@newsblog.com',
    defaultFromName: 'News Blog | Notifications',
    transportOptions: {
      host: process.env.SMTP_HOST,
      port: Number(process.env.SMTP_PORT),
      secure: false,
    },
  }),
  sharp,
  plugins: [
    s3Storage({
      bucket: process.env.S3_BUCKET_NAME || '',
      config: {
        region: process.env.S3_REGION,
        endpoint: process.env.S3_ENDPOINT,
        forcePathStyle: true,
        credentials: {
          accessKeyId: process.env.S3_ACCESS_KEY_ID || '',
          secretAccessKey: process.env.S3_SECRET_ACCESS_KEY || '',
        },
      },
      collections: {
        [Media.slug]: {
          generateFileURL: generatePublicFileURL,
          prefix: 'public/media',
        },
      },
    }),
  ],
}

export default buildConfig(payloadConfig)
