{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DeriveGeneric #-}

module PortfolioTracker.HttpClient
  ( getPrice,
    getCoins,
  )
where

import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status (statusCode)
import Prelude
import Data.ByteString.Lazy
import Data.Aeson
import Data.Text (Text)
import Data.Map
import GHC.Generics

data Api =
  PingApi | PriceApi | CoinsApi

newtype Currency = Currency Text
  deriving (FromJSON, FromJSONKey, Show, Ord, Eq)

newtype Money = Money Rational
  deriving (FromJSON, Show)

data Price = Price
  {
    currency :: Currency,
    value :: Money
  }

data Coin = Coin
  {
    id :: String,
    symbol :: String,
    name :: Text
  }
  deriving (Generic, Show)

instance FromJSON Coin

getApiPath :: Api -> String
getApiPath api =
  case api of
    PingApi -> "https://api.coingecko.com/api/v3/ping"
    PriceApi -> "https://api.coingecko.com/api/v3/simple/price"
    CoinsApi -> "https://api.coingecko.com/api/v3/coins/list"

getCoins :: IO (Maybe [Coin])
getCoins = do
  request <- parseRequest $ getApiPath CoinsApi
  response <- sendRequest request
  pure $ decode response

getPrice :: IO (Maybe (Map Currency (Map Currency Money)))
getPrice = do
  initialRequest <- parseRequest $ getApiPath PriceApi
  let request = setQueryString [("ids", Just "bitcoin,ethereum"), ("vs_currencies", Just "usd,eur")] initialRequest
  response <- sendRequest request
  pure $ decode response

sendRequest :: Request -> IO ByteString
sendRequest req = do
  manager <- newManager tlsManagerSettings
  response <- httpLbs req manager
  pure $ responseBody response
