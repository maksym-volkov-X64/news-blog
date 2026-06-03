import { Access, FieldAccess, PayloadRequest } from 'payload'

import { UserRole } from './types'
import { User } from './types/generated-types'

export const checkRole = (allRoles: User['roles'] = [], user?: User | null): boolean => {
  if (
    user &&
    allRoles &&
    allRoles.some((role) => user?.roles?.some((individualRole) => individualRole === role))
  )
    return true

  return false
}

// Collections and Globals

export const rootAccess: Access = ({ req: { user } }) => checkRole([UserRole.Root], user)
export const anyAdminAccess: Access = ({ req: { user } }) =>
  checkRole([UserRole.Root, UserRole.Admin], user)
export const anyManagerAccess: Access = ({ req: { user } }) =>
  checkRole([UserRole.Root, UserRole.Admin, UserRole.ContentManager], user)

export const anyoneAccess: Access = () => true

export const anyAdminOrSignedInAccess: Access<any> = ({ req }) => {
  if (checkRole([UserRole.Root, UserRole.Admin], req.user)) return true

  return !!req.user
}

export const anyManagerOrPublishedAccess: Access = ({ req: { user } }) => {
  if (user && checkRole([UserRole.Root, UserRole.Admin], user)) return true

  return { _status: { equals: 'published' } }
}

// Admin UI collections and globals access

type AdminAccess = ({ req }: { req: PayloadRequest }) => boolean | Promise<boolean>

export const anyAdminAdminUIAccess: AdminAccess = ({ req: { user } }) =>
  checkRole([UserRole.Root, UserRole.Admin], user)
export const anyManagerAdminUIAccess: AdminAccess = ({ req: { user } }) =>
  checkRole([UserRole.Root, UserRole.Admin, UserRole.ContentManager], user)

// Field

export const rootFieldAccess: FieldAccess = ({ req: { user } }) => checkRole([UserRole.Root], user)
export const anyAdminFieldAccess: FieldAccess = ({ req: { user } }) =>
  checkRole([UserRole.Root, UserRole.Admin], user)
export const anyManagerFieldAccess: FieldAccess = ({ req: { user } }) =>
  checkRole([UserRole.Root, UserRole.Admin, UserRole.ContentManager], user)

// export const
