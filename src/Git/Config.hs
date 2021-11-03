{-# LANGUAGE OverloadedStrings #-}
module Git.Config where

import Data.Ini.Config
import Data.Text
import System.IO

data Config = Config {
    formatVersion :: Int
} deriving (Show)

readConfig :: String -> IO Config
readConfig file =
  openFile file ReadMode >>=
  hGetContents >>=
  (\config -> return $ parseIniFile (pack config) configParser) >>=
  return . handleError
  
configParser :: IniParser Config
configParser = do
  section "core" $ do
    formatVersion <- fieldOf "repositoryformatversion" number
    return Config { formatVersion = formatVersion }

handleError :: Either String Config -> Config
handleError (Right config) = config
handleError (Left errorText) = error ("error parsing config: " ++ errorText)
