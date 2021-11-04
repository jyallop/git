{-# LANGUAGE TemplateHaskell #-}
module Git.Repository where

import Git.Config
import System.FilePath.Posix
import Control.Lens
import System.Directory

data Repository = Repository {
  _worktree :: FilePath,
  _gitdir :: FilePath,
  _config :: Config
  } deriving (Show)

makeLenses ''Repository

buildRepo :: FilePath -> FilePath -> Config -> Repository
buildRepo worktree gitdir config = Repository {
  _worktree = worktree,
  _gitdir = gitdir,
  _config = config
  }

configFilePath :: Repository -> FilePath
configFilePath repo = (repo ^. gitdir) </> "config"

verifyRepository :: FilePath -> FilePath -> FilePath -> IO Bool
verifyRepository worktree gitdir configpath = do
  worktreeExists <- doesDirectoryExist worktree
  gitdirExists <- doesDirectoryExist gitdir
  configExists <- doesFileExist configpath
  return $ worktreeExists && gitdirExists && configExists

verifyRepo :: Repository -> IO Bool
verifyRepo (Repository { _worktree = wt, _gitdir = gd, _config = c }) = verifyRepository wt gd "config"

createRepo :: FilePath -> IO Repository
createRepo worktree =
  let gitdir = worktree </> ".git"
  in
  createDirectoryIfMissing True gitdir >>
  createConfig gitdir >>
  readConfig (worktree </> ".git" </> "config") >>=
  return . buildRepo worktree ".git" 
