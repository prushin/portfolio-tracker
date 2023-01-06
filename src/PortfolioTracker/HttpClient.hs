{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module PortfolioTracker.HttpClient
  ( getPrice,
  )
where

import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status (statusCode)
import Prelude
import Data.ByteString.Lazy
import Data.Aeson (object, (.=), encode)
import Data.Text (Text)

data Api =
  Ping | Price | Coins

getApiPath :: Api -> String
getApiPath api =
  case api of
    Ping -> "https://api.coingecko.com/api/v3/ping"
    Price -> "https://api.coingecko.com/api/v3/simple/price"
    Coins -> "https://api.coingecko.com/api/v3/coins/list"

getPrice :: IO (Response ByteString)
getPrice = do
  initialRequest <- parseRequest $ getApiPath Price
  let request = setQueryString [("ids", Just "bitcoin"), ("vs_currencies", Just "usd,eur")] initialRequest
  print $ getUri request
  sendRequest request

sendRequest :: Request -> IO (Response ByteString)
sendRequest req = do
  manager <- newManager tlsManagerSettings
  response <- httpLbs req manager
  pure response
