{-# LANGUAGE OverloadedStrings #-}
module PortfolioTracker.HttpClient(
    sendRequest,
    req,
  )
  where

import Prelude
import qualified Control.Exception as E
import Control.Concurrent (forkIO, threadDelay)
import qualified Data.ByteString.Char8 as C8
import Network.HTTP.Types
import Network.Run.TCP (runTCPClient) -- network-run

import Network.HTTP2.Client

serverName :: String
serverName = "api.coingecko.com"

sendRequest :: Request -> IO ()
sendRequest req = runTCPClient serverName "80" runHTTP2Client
  where
    cliconf = ClientConfig "https" (C8.pack serverName) 40
    runHTTP2Client s = E.bracket (allocSimpleConfig s 4096)
                                 freeSimpleConfig
                                 (\conf -> run cliconf conf client)
    client :: Client ()
    client sr = do
        _ <- forkIO $ sr req $ \rsp -> do
            print rsp
            getResponseBodyChunk rsp >>= C8.putStrLn
        sr req $ \rsp -> do
            threadDelay 100000
            print rsp
            getResponseBodyChunk rsp >>= C8.putStrLn


req = requestNoBody methodGet "/api/v3/ping" []
