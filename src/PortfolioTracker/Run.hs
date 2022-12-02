module PortfolioTracker.Run (main) where

import Prelude
import PortfolioTracker.HttpClient

main :: IO ()
main = do
  res <- sendRequest req
  print res
  putStrLn "Hello!!!"
