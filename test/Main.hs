module Main
  ( main,
  )
where

import Prelude
import qualified Spec
import Test.Hspec.Core.Formatters.V1
import Test.Hspec.Runner

main :: IO ()
main = do
  hspecWith
    defaultConfig
      { configFormatter = Just progress
      }
    Spec.spec
