module Tests.Language.Interpreter.Blocks
  ( blockTests
  ) where

import           Test.Framework                 (Test, testGroup)
import           Test.Framework.Providers.HUnit (testCase)
import           Test.HUnit                     (Assertion, assertEqual)

import           Gfx                            (Scene (..))
import qualified Gfx.Ast                        as GA
import qualified Language
import           Language.Ast
import           Language.Interpreter
import qualified Language.StdLib                as SL

blockTests :: Test
blockTests =
  testGroup
    "Block Tests"
    [testCase "Simple block tests" test_basic_block_calling]

test_basic_block_calling :: Assertion
test_basic_block_calling =
  let program =
        "a = (sizeX, sizeY) =>\n\tscale(sizeX, sizeY)\n\trunBlock()\n\na(2, 1)\n\tbox(1)"
      interpreterState = Language.initialState 1 []
      result = do
        ast <- Language.parse program
        let ((result, _), _) = Language.createGfx interpreterState ast
        scene <- result
        return $ sceneGfx scene
      expected =
        Right
          [ GA.MatrixCommand (GA.Scale 2 1 0) Nothing
          , GA.ShapeCommand (GA.Cube 1 1 1) Nothing
          ]
   in assertEqual "" expected result
