module Board.Position exposing (..)


type RowIndex
    = RowIndex Int


type ColumnIndex
    = ColumnIndex Int


type Position
    = Position ( RowIndex, ColumnIndex )


unwrapRow : Position -> Int
unwrapRow (Position ( RowIndex r, _ )) =
    r


toTuple : Position -> ( Int, Int )
toTuple (Position ( RowIndex r, ColumnIndex c )) =
    ( r, c )


sort : List Position -> List Position
sort =
    List.sortBy toTuple


haveSameRow : Position -> Position -> Bool
haveSameRow pos1 pos2 =
    let
        (Position ( RowIndex a, _ )) =
            pos1

        (Position ( RowIndex b, _ )) =
            pos2
    in
        a == b


fromTuple : ( Int, Int ) -> Position
fromTuple ( r, c ) =
    Position ( RowIndex r, ColumnIndex c )


neighbors : Position -> List Position
neighbors position =
    let
        ( r, c ) =
            toTuple position
    in
        [ ( r, c - 1 ) -- north
        , ( r, c + 1 ) -- south
        , ( r - 1, c ) -- east
        , ( r + 1, c ) -- west
        ]
            |> List.map fromTuple
