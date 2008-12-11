{- DO NOT EDIT THIS FILE
   THIS FILE IS AUTOMAGICALLY GENERATED AND YOUR CHANGES WILL BE EATEN BY THE GENERATOR OVERLORD

   All changes should go into the Model file (e.g. App/Models/ExampleModel.hs) and
   not into the base file (e.g. App/Models/Bases/ExampleModelBase.hs) -}

module App.Models.Bases.AuthorModelBase ( 
 module App.Models.Bases.AuthorModelBase, 
 module App.Models.Bases.ModelBase) where

import App.Models.Bases.ModelBase
import qualified Database.HDBC as HDBC
import System.Time

data Author = Author {
    id :: Int64,    name :: Maybe String
    } deriving (Eq, Show)

instance DatabaseModel Author where
    tableName _ = "author"

instance IsModel Author where
    insert conn m = do
        res <- liftIO $ HDBC.run conn " INSERT INTO author (id,name) VALUES (?,?)"
                  [HDBC.toSql $ id m , HDBC.toSql $ name m]
        liftIO $ HDBC.commit conn
        i <- liftIO $ HDBC.catchSql (HDBC.quickQuery' conn "SELECT lastval()" []) (\_ -> HDBC.commit conn >> (return $ [[HDBC.toSql (0 :: Int)]]) ) 
        return $ HDBC.fromSql $ head $ head i
    findAll conn = do
        res <- liftIO $ HDBC.quickQuery' conn "SELECT id , name FROM author" []
        return $ map (\r -> Author (HDBC.fromSql (r !! 0)) (HDBC.fromSql (r !! 1))) res
    findAllBy conn ss sp = do
        res <- liftIO $ HDBC.quickQuery' conn ("SELECT id , name FROM author WHERE (" ++ ss ++ ") ")  sp
        return $ map (\r -> Author (HDBC.fromSql (r !! 0)) (HDBC.fromSql (r !! 1))) res
    findOneBy conn ss sp = do
        res <- liftIO $ HDBC.quickQuery' conn ("SELECT id , name FROM author WHERE (" ++ ss ++ ") LIMIT 1")  sp
        return $ (\r -> Author (HDBC.fromSql (r !! 0)) (HDBC.fromSql (r !! 1))) (head res)
instance HasFindByPrimaryKey Author  (Int64)  where
    find conn pk@(pk1) = do
        res <- liftIO $ HDBC.quickQuery' conn ("SELECT id , name FROM author WHERE (id = ? )") [HDBC.toSql pk1]
        case res of
          [] -> throwDyn $ HDBC.SqlError
                           {HDBC.seState = "",
                            HDBC.seNativeError = (-1),
                            HDBC.seErrorMsg = "No record found when finding by Primary Key:author : " ++ (show pk)
                           }
          r:[] -> return $ Author (HDBC.fromSql (r !! 0)) (HDBC.fromSql (r !! 1))
          _ -> throwDyn $ HDBC.SqlError
                           {HDBC.seState = "",
                            HDBC.seNativeError = (-1),
                            HDBC.seErrorMsg = "Too many records found when finding by Primary Key:author : " ++ (show pk)
                           }

    update conn m = do
        res <- liftIO $ HDBC.run conn "UPDATE author SET (id , name) = (?,?) WHERE (id = ? )"
                  [HDBC.toSql $ id m , HDBC.toSql $ name m, HDBC.toSql $ id m]
        liftIO $ HDBC.commit conn
        return ()
