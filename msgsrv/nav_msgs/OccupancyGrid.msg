#////////////////////////////////////////////////////////////////////////////////
#/// @struct     nav_msgs/OccupancyGrid
#/// @brief      占有グリッド地図
#///
#/// グリッドの占有状態で地図を表現したデータ型です。
#/// 地図やコストマップなどに使用されます。
#/// 5cm四方など、決まったサイズのセルで地図を区切り、地図の場合は、各セルを、
#/// 「占有されたセル(100)」、「占有されていないセル(0)」、「未知のセル(-1)」の
#/// 3つで区分して表現します。コストマップの場合は、さらに100と0の間で、コストを
#/// 表現する任意の値が入ります。
#/// 解像度（セルの大きさ）、地図の大きさ（縦横のセル数）、オリジン（座標軸に
#/// おけるセル(0,0)の位置）、そして各セルの占有率を保持した配列データから成ります。
#///
#////////////////////////////////////////////////////////////////////////////////

Header header         #//!< ヘッダ
MapMetaData info      #//!< 地図付帯情報
int8[] data           #//!< 地図データ
