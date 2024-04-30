{-# LANGUAGE CApiFFI #-}
module OpenCascade.GP.Lin
( Lin
, new
, location
, direction
, setLocation
, setDirection
, position
, angle
, contains
, distance
, distanceL
, squareDistance
, squareDistanceL
, normal
, mirror
, mirrored
, rotate
, rotated
, scale
, scaled
, transform
, transformed
, translate
, translated
, translateP
, translatedP
) where

import OpenCascade.GP.Types
import OpenCascade.GP.Internal.Destructors
import Foreign.C
import Foreign.Ptr
import Data.Coerce (coerce)
import Data.Acquire 

foreign import capi unsafe "hs_gp_Lin.h hs_new_gp_Lin" rawNew :: Ptr Pnt -> Ptr Dir -> IO (Ptr Lin)

new :: Ptr Pnt -> Ptr Dir -> Acquire (Ptr Lin)
new pnt dir = mkAcquire (rawNew pnt dir) deleteLin

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Location" location :: Ptr Lin -> IO (Ptr Dir)
foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Direction" direction :: Ptr Lin -> IO (Ptr Pnt)

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_SetLocation" setLocation :: Ptr Lin -> Ptr Pnt -> IO ()
foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_SetDirection" setDirection :: Ptr Lin -> Ptr Dir -> IO ()

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Position" position :: Ptr Lin -> IO (Ptr Ax1)

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Angle" rawAngle :: Ptr Lin -> Ptr Lin -> IO CDouble

angle :: Ptr Lin -> Ptr Lin -> IO Double
angle = coerce rawAngle

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Contains" rawContains :: Ptr Lin -> Ptr Pnt -> CDouble -> IO CBool

contains :: Ptr Lin -> Ptr Pnt -> Double -> IO Bool
contains lin pnt tol = (/= 0) <$> rawContains lin pnt (CDouble tol)

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Distance" rawDistance :: Ptr Lin -> Ptr Pnt -> IO CBool

distance :: Ptr Lin -> Ptr Pnt -> IO Bool
distance lin pnt = (/= 0) <$> rawDistance lin pnt

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_DistanceL" rawDistanceL :: Ptr Lin -> Ptr Lin -> IO CBool

distanceL :: Ptr Lin -> Ptr Lin -> IO Bool
distanceL lin other = (/= 0) <$> rawDistanceL lin other

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_SquareDistance" rawSquareDistance :: Ptr Lin -> Ptr Pnt -> IO CDouble

squareDistance :: Ptr Lin -> Ptr Pnt -> IO Double
squareDistance = coerce rawSquareDistance

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_SquareDistanceL" rawSquareDistanceL :: Ptr Lin -> Ptr Lin -> IO CDouble

squareDistanceL :: Ptr Lin -> Ptr Lin -> IO Double
squareDistanceL = coerce rawSquareDistanceL

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Normal" normal :: Ptr Lin -> Ptr Pnt -> IO (Ptr Lin)

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Mirror" mirror :: Ptr Lin -> Ptr Pnt -> IO ()

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Mirrored" mirrored :: Ptr Lin -> Ptr Pnt -> IO (Ptr Lin)

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Rotate" rawRotate :: Ptr Lin -> Ptr Ax1 -> CDouble -> IO ()

rotate :: Ptr Lin -> Ptr Ax1 -> Double -> IO ()
rotate = coerce rawRotate

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Rotated" rawRotated :: Ptr Lin -> Ptr Ax1 -> CDouble -> IO (Ptr Lin)

rotated :: Ptr Lin -> Ptr Ax1 -> Double -> Acquire (Ptr Lin)
rotated lin ax1 amount = mkAcquire (rawRotated lin ax1 (CDouble amount)) deleteLin

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Scale" rawScale :: Ptr Lin -> Ptr Pnt -> CDouble -> IO ()

scale :: Ptr Lin -> Ptr Pnt -> Double -> IO ()
scale = coerce rawScale

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Scaled" rawScaled :: Ptr Lin -> Ptr Pnt -> CDouble -> IO (Ptr Lin)

scaled :: Ptr Lin -> Ptr Pnt -> Double -> Acquire (Ptr Lin)
scaled lin pnt factor = mkAcquire (rawScaled lin pnt (CDouble factor)) deleteLin

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Transform" transform :: Ptr Lin -> Ptr Trsf -> IO ()

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Transformed" rawTransformed :: Ptr Lin -> Ptr Trsf -> IO (Ptr Lin)

transformed :: Ptr Lin -> Ptr Trsf -> Acquire (Ptr Lin)
transformed lin trsf = mkAcquire (rawTransformed lin trsf) deleteLin

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Translate" translate :: Ptr Lin -> Ptr Vec -> IO ()

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_Translated" rawTranslated :: Ptr Lin -> Ptr Vec -> IO (Ptr Lin)

translated :: Ptr Lin -> Ptr Vec -> Acquire (Ptr Lin)
translated lin vec = mkAcquire (rawTranslated lin vec) deleteLin

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_TranslateP" translateP :: Ptr Lin -> Ptr Pnt -> Ptr Pnt -> IO ()

foreign import capi unsafe "hs_gp_Lin.h hs_gp_Lin_TranslatedP" rawTranslatedP :: Ptr Lin -> Ptr Pnt -> Ptr Pnt -> IO (Ptr Lin)

translatedP :: Ptr Lin -> Ptr Pnt -> Ptr Pnt -> Acquire (Ptr Lin)
translatedP lin p1 p2 = mkAcquire (rawTranslatedP lin p1 p2) deleteLin
