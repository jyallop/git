module Git.Repository where

import Git.Config

data Repository = Repository Path Path Config

newtype Path = Path String

