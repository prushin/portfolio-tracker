module PortfolioTracker.Run (main) where

import PortfolioTracker.HttpClient
import Prelude

main :: IO ()
main = do
  print "try to run rpc"
  --print $ show req
  res <- getCoins
  print res
  putStrLn "Hello!!!"
