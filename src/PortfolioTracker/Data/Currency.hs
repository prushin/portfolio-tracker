module PortfolioTracker.Data.Currency
  (Currency(..), test) where

import Data.Text
import Prelude

test :: String
test = "test"

newtype Currency = Currency
  { code :: Text
  }
  deriving newtype
    ( Eq,
      Show,
      Read
    )
