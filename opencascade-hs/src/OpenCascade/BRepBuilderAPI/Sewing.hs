{-# LANGUAGE CApiFFI #-}
module OpenCascade.BRepBuilderAPI.Sewing
( Sewing
, new
, load
, add
, perform
, sewedShape
) where 

import qualified OpenCascade.TopoDS.Types as TopoDS
import OpenCascade.TopoDS.Internal.Destructors (deleteShape)
import OpenCascade.BRepBuilderAPI.Internal.Destructors (deleteSewing)
import OpenCascade.BRepBuilderAPI.Types (Sewing)
import Foreign.Ptr (Ptr)
import Foreign.C (CBool (..), CDouble (..))
import OpenCascade.Internal.Bool (boolToCBool)
import Data.Acquire (Acquire, mkAcquire)
import Data.Coerce (coerce)

foreign import capi unsafe "hs_BRepBuilderAPI_Sewing.h hs_new_BRepBuilderAPI_Sewing" rawNew :: CDouble -> CBool -> CBool -> CBool -> CBool -> IO (Ptr Sewing)

new :: Double -> Bool -> Bool -> Bool -> Bool -> Acquire (Ptr Sewing)
new tolerance opt1 opt2 opt3 opt4 = mkAcquire (rawNew (coerce tolerance) (boolToCBool opt1) (boolToCBool opt2) (boolToCBool opt3) (boolToCBool opt4)) deleteSewing

foreign import capi unsafe "hs_BRepBuilderAPI_Sewing.h hs_BRepBuilderAPI_Sewing_load" load :: Ptr Sewing -> Ptr TopoDS.Shape -> IO ()

foreign import capi unsafe "hs_BRepBuilderAPI_Sewing.h hs_BRepBuilderAPI_Sewing_add" add :: Ptr Sewing -> Ptr TopoDS.Shape -> IO ()

foreign import capi unsafe "hs_BRepBuilderAPI_Sewing.h hs_BRepBuilderAPI_Sewing_perform" perform :: Ptr Sewing -> IO ()

foreign import capi unsafe "hs_BRepBuilderAPI_Sewing.h hs_BRepBuilderAPI_Sewing_sewedShape" rawSewedShape :: Ptr Sewing -> IO (Ptr TopoDS.Shape)

sewedShape :: Ptr Sewing -> Acquire (Ptr TopoDS.Shape)
sewedShape sewing = mkAcquire (rawSewedShape sewing) (deleteShape)



