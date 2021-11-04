module Main where
import System.Console.ArgParser
import Control.Applicative
import Data.Ini.Config
import Git.Config
import Git.Repository
import System.FilePath.Posix

data Git = Init String 
         deriving (Eq, Show)
  
gitParser :: IO (CmdLnInterface Git)
gitParser = mkSubParser
  [
    ("init", mkDefaultApp
      (Init `parsedBy` optFlag "./" "directory" `Descr` "the directory to initialize the new git repository")
       "init")
  ]

main = do
  interface <- gitParser
  runApp interface git

git :: Git -> IO ()
git (Init dir) =
  createRepo dir >>=
  verifyRepo >>=
  (\isVerified -> if isVerified then
      putStrLn "Repo Created Successfully"
                  else
                    putStrLn "Error in initializing repo")

