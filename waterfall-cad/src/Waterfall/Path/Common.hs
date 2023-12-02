{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
module Waterfall.Path.Common 
( line
, lineTo
, lineRelative
, arcVia
, arcViaTo
, arcViaRelative
, bezier
, bezierTo
, bezierRelative
, pathFrom
, pathFromTo
) where
import Data.Acquire
import qualified OpenCascade.TopoDS as TopoDS
import qualified OpenCascade.GP as GP
import Foreign.Ptr
import Waterfall.Internal.Path (Path (..))
import Waterfall.TwoD.Internal.Path2D (Path2D (..))
import Control.Arrow (second)
import Data.Foldable (foldl', traverse_)
import qualified OpenCascade.BRepBuilderAPI.MakeWire as MakeWire
import Control.Monad.IO.Class (liftIO)
import qualified OpenCascade.BRepBuilderAPI.MakeEdge as MakeEdge
import qualified OpenCascade.GC.MakeArcOfCircle as MakeArcOfCircle
import OpenCascade.Inheritance (upcast)
import qualified OpenCascade.NCollection.Array1 as NCollection.Array1
import qualified OpenCascade.Geom.BezierCurve as BezierCurve
import Data.Proxy (Proxy (..))
import Linear (V3 (..), V2 (..))
import qualified OpenCascade.GP.Pnt as GP.Pnt

class AnyPath point path | point -> path where
    fromWire :: Proxy point -> Acquire (Ptr TopoDS.Wire) -> path
    pointToGPPnt :: point -> Acquire (Ptr GP.Pnt)

edgesToPath :: (AnyPath point path) => Proxy point -> Acquire [Ptr TopoDS.Edge] -> path
edgesToPath proxy es = fromWire proxy $ do
    edges <- es
    builder <- MakeWire.new
    liftIO $ traverse_ (MakeWire.addEdge builder) edges
    MakeWire.wire builder

toProxy :: a -> Proxy a
toProxy = pure

-- | A straight line between two points
line :: (AnyPath point path) => point -> point -> path
line start end = edgesToPath (toProxy start) $ do
    pt1 <- pointToGPPnt start
    pt2 <- pointToGPPnt end
    pure <$> MakeEdge.fromPnts pt1 pt2

-- | Version of `line` designed to work with `pathFrom`
lineTo :: (AnyPath point path) => point -> point -> (point, path)
lineTo end = \start -> (end, line start end) 

-- | Version of `line` designed to work with `pathFrom`
-- 
-- With relative points; specifying the distance of the endpoint
-- relative to the start of the line, rather than in absolute space.
lineRelative :: (AnyPath point path, Num point) => point -> point -> (point, path)
lineRelative dEnd = do
    end <- (+ dEnd)
    lineTo end

-- | Section of a circle based on three arguments, the start point, a point on the arc, and the endpoint
arcVia ::(AnyPath point path) => point -> point -> point -> path
arcVia start mid end = edgesToPath (toProxy start) $ do
    s <- pointToGPPnt start
    m <- pointToGPPnt mid
    e <- pointToGPPnt end
    theArc <- MakeArcOfCircle.from3Pnts s m e
    pure <$> MakeEdge.fromCurve (upcast theArc)

-- | Version of `arcVia` designed to work with `pathFrom`
--
-- The first argument is a point on the arc
-- The second argument is the endpoint of the arc
arcViaTo :: (AnyPath point path) => point -> point -> point -> (point, path)
arcViaTo mid end = \start -> (end, arcVia start mid end) 

-- | Version of `arcVia` designed to work with `pathFrom`
-- 
-- With relative points; specifying the distance of the midpoint and endpoint
-- relative to the start of the line, rather than in absolute space.
arcViaRelative :: (AnyPath point path, Num point) => point -> point -> point -> (point, path)
arcViaRelative dMid dEnd = do
    mid <- (+ dMid) 
    end <- (+ dEnd) 
    arcViaTo mid end

-- | Bezier curve of order 3
-- 
-- The arguments are, the start of the curve, the two control points, and the end of the curve
bezier :: (AnyPath point path) => point -> point -> point -> point -> path
bezier start controlPoint1 controlPoint2 end = edgesToPath (toProxy start) $ do
    s <- pointToGPPnt start
    c1 <- pointToGPPnt controlPoint1
    c2 <- pointToGPPnt controlPoint2
    e <- pointToGPPnt end
    arr <- NCollection.Array1.newGPPntArray 1 4
    liftIO $ do 
        NCollection.Array1.setValueGPPnt arr 1 s
        NCollection.Array1.setValueGPPnt arr 2 c1
        NCollection.Array1.setValueGPPnt arr 3 c2
        NCollection.Array1.setValueGPPnt arr 4 e
    b <- BezierCurve.toHandle =<< BezierCurve.fromPnts arr
    pure <$> MakeEdge.fromCurve (upcast b)

-- | Version of `bezier` designed to work with `pathFrom`
bezierTo :: (AnyPath point path) => point -> point -> point -> point -> (point, path)
bezierTo controlPoint1 controlPoint2 end = \start -> (end, bezier start controlPoint1 controlPoint2 end) 

-- | Version of `bezier` designed to work with `pathFrom`
-- 
-- With relative points; specifying the distance of the control points and the endpoint
-- relative to the start of the line, rather than in absolute space.
bezierRelative :: (AnyPath point path, Num point) => point -> point -> point -> point -> (point, path)
bezierRelative dControlPoint1 dControlPoint2 dEnd = do
    controlPoint1 <- (+ dControlPoint1)
    controlPoint2 <- (+ dControlPoint2)
    end <- (+ dEnd)
    bezierTo controlPoint1 controlPoint2 end

-- | When combining paths, we're generally interested in pairs of paths that share a common endpoint.
--
-- Rather than having to repeat these common endpoints, `pathFrom` can be used to combine a list of path components.
-- 
-- Where a path component is a function from a start point, to a tuple of an end point, and a path; @V2 Double -> (V2 Double, Path2D)@. 
-- 
-- A typical use of `pathFrom` uses a list of functions with the suffix \"To\" or \"Relative\", e.g:
--
-- @
--Path.pathFrom zero 
--    [ Path.bezierRelative (V3 0 0 0.5) (V3 0.5 0.5 0.5) (V3 0.5 0.5 1)
--    , Path.bezierRelative (V3 0 0 0.5) (V3 (-0.5) (-0.5) 0.5) (V3 (-0.5) (-0.5) 1)
--    , Path.arcViaRelative (V3 0 1 1) (V3 0 2 0)
--    , Path.lineTo (V3 0 2 0) 
--    ] @
pathFrom :: (Monoid path) => point -> [point -> (point, path)] -> path
pathFrom start commands = snd $ pathFromTo commands start 
     
-- | Combines a list of "path components", as used by `pathFrom`
pathFromTo :: (Monoid path) => [point -> (point, path)] -> point -> (point, path)
pathFromTo commands start = 
    let go (pos, paths) cmd = second (:paths) (cmd pos)
        (end, allPaths) = foldl' go (start, []) commands
     in (end, mconcat allPaths)

instance AnyPath (V3 Double) Path where
    fromWire :: Proxy (V3 Double) -> Acquire (Ptr TopoDS.Wire) -> Path
    fromWire _proxy = Path
    pointToGPPnt :: V3 Double -> Acquire (Ptr GP.Pnt)
    pointToGPPnt (V3 x y z) = GP.Pnt.new x y z 

instance AnyPath (V2 Double) Path2D where
    fromWire :: Proxy (V2 Double) -> Acquire (Ptr TopoDS.Wire) -> Path2D
    fromWire _proxy = Path2D
    pointToGPPnt :: V2 Double -> Acquire (Ptr GP.Pnt)
    pointToGPPnt (V2 x y) = GP.Pnt.new x y 0
