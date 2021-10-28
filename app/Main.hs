{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Console.ArgParser
import Control.Applicative
import Data.Ini.Config
import Git.Config
import Git.Repository
import Data.Text
import System.IO

data Git = Init String Bool 
         deriving (Eq, Show)
  
gitParser :: IO (CmdLnInterface Git)
gitParser = mkSubParser
  [
    ("init", mkDefaultApp
      (Init `parsedBy` optFlag "./" "directory" `Descr` "the directory to initialize the new git repository"
            `andBy` boolFlag  "force") "init")
  ]

main = do
  interface <- gitParser
  runApp interface git

git :: Git -> IO ()
git (Init dir forced) =
  openFile (dir ++ ".git/config") ReadMode >>= hGetContents >>= (\config -> 
  (putStrLn $ (show (parseIniFile (pack config) configParser))) >>
  putStrLn "Done")

configParser :: IniParser Config
configParser = do
  section "core" $ do
    formatVersion <- fieldOf "repositoryformatversion" number
    return Config { formatVersion = formatVersion }
