import {
  AlignFeature,
  BlocksFeature,
  BoldFeature,
  FeatureProviderServer,
  HeadingFeature,
  HorizontalRuleFeature,
  InlineCodeFeature,
  InlineToolbarFeature,
  ItalicFeature,
  lexicalEditor,
  LinkFeature,
  OrderedListFeature,
  ParagraphFeature,
  StrikethroughFeature,
  SubscriptFeature,
  SuperscriptFeature,
  UnderlineFeature,
  UnorderedListFeature,
  UploadFeature,
} from '@payloadcms/richtext-lexical'
import { RichTextAdapterProvider } from 'payload'

import { Collection } from '@cms/types'
import { imageWithAspectRatioBlock } from './blocks/imageWithAspectRatio'

export const baseHeadingFeature = HeadingFeature({
  enabledHeadingSizes: ['h2', 'h3', 'h4', 'h5'],
})

export const allBlockFeature = BlocksFeature({
  blocks: [imageWithAspectRatioBlock],
})

export const baseEditorFeatures: FeatureProviderServer<undefined, undefined, any>[] = [
  ParagraphFeature(),
  AlignFeature(),
  BoldFeature(),
  ItalicFeature(),
  UnderlineFeature(),
  StrikethroughFeature(),
  InlineCodeFeature(),
  UnorderedListFeature(),
  OrderedListFeature(),
  SuperscriptFeature(),
  SubscriptFeature(),
  InlineToolbarFeature(),
  HorizontalRuleFeature(),
  // @ts-ignore
  LinkFeature({
    enabledCollections: [Collection.Posts],
  }),
  // @ts-ignore
  UploadFeature(),
]

export const getDefaultEditor = () =>
  lexicalEditor({
    features: [...baseEditorFeatures, baseHeadingFeature, allBlockFeature],
  }) as unknown as RichTextAdapterProvider<object, any, any>

export const getHeroEditor = () =>
  lexicalEditor({
    features: [...baseEditorFeatures, HeadingFeature()],
  }) as unknown as RichTextAdapterProvider<object, any, any>
