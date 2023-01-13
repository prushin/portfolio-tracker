module TestSpec
  ( spec,
  )
where

import Prelude
import Test.Hspec

spec :: Spec
spec =
  it "TestTest" $ do
    print "testtesttest"
    True `shouldBe` True
