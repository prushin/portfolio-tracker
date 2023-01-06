{-# LANGUAGE OverloadedStrings #-}

module PortfolioTracker.HttpClient
  ( sendRequest,
  )
where

import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status (statusCode)
import Prelude

sendRequest :: IO ()
sendRequest = do
  manager <- newManager tlsManagerSettings

  request <- parseRequest "https://api.coingecko.com/api/v3/ping"
  response <- httpLbs request manager
  print response
  pure ()

--sendRequest :: Request -> IO ()
--sendRequest req = do
--  runTCPClient serverName "443" runHTTP2Client
--  where
--    cliconf = ClientConfig "https" (C8.pack serverName) 20
--    runHTTP2Client s =
--      E.bracket
--        (allocSimpleConfig s 4096)
--        freeSimpleConfig
--        (\conf -> run cliconf conf client)
--    client :: Client ()
--    client sr = do
--      _ <- forkIO $
--        sr req $ \rsp -> do
--          print "=================="
--          print rsp
--          getResponseBodyChunk rsp >>= C8.putStrLn
--      sr req $ \rsp -> do
--        threadDelay 100000
--        print rsp
--        getResponseBodyChunk rsp >>= C8.putStrLn
--
--req = requestNoBody methodGet "/api/v3/ping" []
