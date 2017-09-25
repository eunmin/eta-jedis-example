{-# LANGUAGE MagicHash #-}

module Main where

import Java
import System.Environment

data {-# CLASS "redis.clients.jedis.Jedis" #-} Jedis = Jedis (Object# Jedis)
  deriving Class

foreign import java unsafe "@new" newJedis :: String -> Java a Jedis

foreign import java unsafe get :: String -> Java Jedis String

foreign import java unsafe set :: String -> String -> Java Jedis String

main :: IO ()
main = do
  args <- getArgs
  result <- java $ do
    jedis <- newJedis "localhost"
    case args of
      ["get", key] -> jedis <.> get key
      ["set", key, value] -> jedis <.> set key value
      _ -> return "Usage: etlas run [get|set] key value"
  putStrLn result
