module Board.Rows exposing (..)

import Color exposing (Color)
import Board.Position exposing (ColumnIndex(..), RowIndex(..))
import Board.Row as Row exposing (Row(..))
import List.Extra as Lextra


type Rows
    = Rows (List Row)


unwrap : Rows -> List Row
unwrap (Rows rows) =
    rows


fromList : List (List (Maybe Color)) -> Rows
fromList list =
    list
        |> List.map Row
        |> Rows


toList : Rows -> List (List (Maybe Color))
toList (Rows rows) =
    rows
        |> List.map Row.unwrap


removeBlock : List ( RowIndex, List ColumnIndex ) -> Rows -> Rows
removeBlock groupedColumnIndices (Rows rows) =
    let
        setRow : RowIndex -> List Row -> Row -> Maybe (List Row)
        setRow (RowIndex rowIndex) rows row =
            Lextra.setAt rowIndex row rows
    in
        case Lextra.uncons groupedColumnIndices of
            Just ( ( RowIndex rowIndex, columnIndices ), restRowGroups ) ->
                Lextra.getAt rowIndex rows
                    |> Maybe.map (Row.removePieces columnIndices)
                    |> Maybe.andThen (setRow (RowIndex rowIndex) rows)
                    |> Maybe.withDefault rows
                    |> Rows
                    |> removeBlock restRowGroups

            Nothing ->
                (Rows rows)


slideDownLeft : Rows -> Rows
slideDownLeft =
    toList
        >> Lextra.transpose
        >> List.map (Row >> Row.slideRight)
        >> List.filter (Row.isNotEmpty)
        >> List.map Row.unwrap
        >> Lextra.transpose
        >> List.map Row
        >> Rows
