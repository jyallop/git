module Main where

import System.Console.ArgParser
import Control.Applicative
import Data.Ini.Config
import Git.Config
import Git.Repository

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
git (Init dir forced) = undefined 

configParser :: IniParser Config
configParser = undefined