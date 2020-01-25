Navigation Stack概要
=======================================

=======================================
Navigation Stackとは
=======================================

Navigation Stackは、オドメトリ情報（ホイールエンコーダ等の内界センサーによる推定自己位置および現在速度）、および、測域センサ情報（障害物までの距離情報）を入力値として、与えられた目標地点／姿勢に到達するための安全な駆動（速度）命令を出力するソフトウェアです。

* 測域センサ情報は、平面レーザーによる2Dレーザースキャンまたは3Dデプスカメラ等によるポイントクラウドを利用可能です。
* TF(Transform tree)と呼ばれる座標軸の相対位置情報を与える必要があります。
* オプションで、Navigationスタックに対して地図を与えることができます。地図を与えることで、Navigationスタックは、より効率的に移動経路の検索を行うことができます。


.. image:: /images/navigation_overview.png
   :scale: 80
   :align: center


=======================================
Navigation Stackの入出力
=======================================

Transform Tree
************************************************************

Transform Tree(TF)とは、ロボットが存在する空間およびロボットの構成要素がそれぞれ持っている座標軸ごとのずれ（x,y,zの相対位置および相対姿勢）がどの程度であるかを、親子関係のツリー構造で表現したものです。

例えば、障害物からの距離情報は、ロボット上に設置されたレーザーから取得されますが、ロボットの障害物回避を考える場合は、ロボットの基準面の位置で考える必要があります。そのため、下図のように、レーザーの中心からの距離情報を、ロボット基準面からの距離情報に変換する必要があります。これを求めるために、基準面の座標軸とレーザーの座標軸とのずれを、Navigationスタックに入力する必要があります。

|

.. image:: /images/simple_robot.png
   :align: center

出典: http://wiki.ros.org/navigation/Tutorials/RobotSetup/TF

|

各座標軸は、フレームIDと呼ばれる文字列により識別されます。Navigationスタックが動作するには、基本的な構成の場合は、mapフレーム → odomフレーム → base_linkフレーム → laserフレーム（または cameraフレーム）の4つの構成要素の相対位置／姿勢（3つのTransform Tree情報）が必要です。

* mapフレームは、Trensform Treeの頂点座標軸で、ロボットが移動する空間で固定となる絶対座標軸です。
* odomフレームは、ロボットのオドメトリ（内界センサーによる推定自己位置）を表すための座標軸です。mapフレームと同じ空間固定座標軸であり、車輪の空転やロボットの横滑り、オドメトリの計算誤差がないならば、mapフレームとのずれは理論上常にゼロとなります。（実際には計算誤差やスリップなどがあるため、mapフレームとのずれは時間とともに拡大していきます。）
* base_linkフレームは、ロボット基準面の中心を原点とする座標軸です。ロボットの移動に伴い、odomフレームとの相対位置／姿勢が変化していきます。
* laserフレームおよびcameraフレームは、ロボット上の測域センサの基準点を原点とする座標軸です。一般的には、測域センサはロボット上に固定据付されるため、base_linkフレームとの相対位置／姿勢は固定値となります。

.. note::

    実際には、例えば、レーザーセンサーを前後に2個搭載するなど、ロボットの構成などに合わせて、適宜TFツリーを構成します。この場合は、map → odom → base_link → laser_front, laser_back のようにするかもしれません。

TFの出力は、:ref:`tf/tfMessage<msg_tf_tfMessage>` 型のメッセージを、/tfトピックへ送出することで行います。通常は、 `TF API <http://wiki.ros.org/ja/tf>`__ を使用してTFを出力します。

メッセージ定義
------------------------------------------------------------

.. _msg_std_msgs_Header:

std_msgs/Header

.. parsed-literal:: 

    uint32 seq       # シーケンス番号
    time stamp       # タイムスタンプ
    string frame_id  # 親フレームID

.. _msg_geometry_msgs_Vector3:

geometry_msgs/Vector3

.. parsed-literal:: 

    float64 x   # x軸差異[m]または速度[m/s][rad/s]
    float64 y   # y軸差異[m]または速度[m/s][rad/s]
    float64 z   # z軸差異[m]または速度[m/s][rad/s]

.. _msg_geometry_msgs_Quaternion:

geometry_msgs/Quaternion

.. parsed-literal:: 

    float64 x   # クォータニオンx
    float64 y   # クォータニオンy
    float64 z   # クォータニオンz
    float64 w   # クォータニオンw

.. _msg_geometry_msgs_Transform:

geometry_msgs/Transform

.. parsed-literal:: 

    :ref:`geometry_msgs/Vector3<msg_geometry_msgs_Vector3>` translation  # 相対位置
    :ref:`geometry_msgs/Quaternion<msg_geometry_msgs_Quaternion>` rotation  # 相対姿勢（クォータニオン）

.. _msg_geometry_msgs_TransformStamped:

geometry_msgs/TransformStamped

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header>` header
    string child_frame_id              # 子フレームID
    :ref:`geometry_msgs/Transform<msg_geometry_msgs_Transform>` transform  # TF情報

.. _msg_tf_tfMessage:

tf/tfMessage

.. parsed-literal:: 

    :ref:`geometry_msgs/TransformStamped<msg_geometry_msgs_TransformStamped>` [] transforms  # TF情報リスト

|

測域センサ情報（レーザースキャン）
************************************************************

レーザースキャンデータは、laser座標軸における、スキャン範囲内の各スキャン単位における、障害物までの距離を通知します。

* 例えば、測定範囲が180度で測定単位が5度のレーザーセンサであれば、36個の距離データ(ranges)を通知します。
* 測定範囲内に何もない部分については、無効値(range_max値または無限大)を入れておきます。
* 測定角度は、前方正面が0[ラジアン]で、右側がマイナス値、左側がプラス値となります。
* intensitiesは、通常は反射強度を入れますが、Navigationスタックでは使われないので、何も入れなくても問題はありません。

.. image:: /images/laser_scan.png
   :align: center

メッセージ定義
------------------------------------------------------------

.. _msg_std_msgs_Header2:

std_msgs/Header

.. parsed-literal:: 

    uint32 seq       # シーケンス番号
    time stamp       # タイムスタンプ
    string frame_id  # フレームID（通常はlaser）

sensor_msgs/LaserScan

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header2>` header
    float32 angle_min         # 測定開始角度[ラジアン]
    float32 angle_max         # 測定終了角度[ラジアン]
    float32 angle_increment   # 測定単位[ラジアン]
    float32 time_increment    # 測定単位間の測定時間[秒]
    float32 scan_time         # 全測定単位の測定時間[秒]
    float32 range_min         # 測定最小距離[m]
    float32 range_max         # 測定最大距離[m]
    float32[] ranges          # 測定データ[m]
    float32[] intensities     # 反射強度データ[単位はデバイス依存]

|

測域センサ情報（ポイントクラウド）
************************************************************

ポイントクラウドデータは、camera座標軸における、点群の各点の座標を通知します。

* pointsに各点の座標を配列として格納します。
* channelsは、intensityやrgbなど点の付帯情報を入れるために定義されていますが、 Navigationスタックでは使われないので、何も入れなくても問題ありません。

.. image:: /images/keypoints_small.png
   :scale: 200
   :align: center

出典: http://pointclouds.org/documentation/

メッセージ定義
------------------------------------------------------------

.. _msg_std_msgs_Header3:

std_msgs/Header

.. parsed-literal:: 

    uint32 seq       # シーケンス番号
    time stamp       # タイムスタンプ
    string frame_id  # フレームID（通常はcamera）

.. _msg_geometry_msgs_Point32:

geometry_msgs/Point32

.. parsed-literal:: 

    float32 x   # x座標[m]
    float32 y   # y座標[m]
    float32 z   # z座標[m]

.. _msg_sensor_msgs_ChannelFloat32:

sensor_msgs/ChannelFloat32

.. parsed-literal:: 

    string name        # チャンネルデータ名称
    float32[] values   # チャンネルデータ値

sensor_msgs/PointCloud

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header3>` header
    :ref:`geometry_msgs/Point32<msg_geometry_msgs_Point32>` [] points         # 点群データ
    :ref:`sensor_msgs/ChannelFloat32<msg_sensor_msgs_ChannelFloat32>` [] channels  # チャンネルデータ（デバイス依存）

|

オドメトリ情報
************************************************************

オドメトリ情報は、odom座標軸におけるロボット(base_link座標軸)の推定自己位置および現在速度（並進速度および回転速度）を通知します。

  * 推定自己位置は、多くの場合、車輪駆動を制御するノードが、車輪回転量から推定される自己位置情報を通知します。（IMUなど、車輪回転量とは別の何らかの手段を組み合わせて、オドメトリ情報の精度を上げることも可能です。）
  * 現在速度は、2Dのナビゲーションでは、x軸並進速度およびz軸回転速度が設定されます。（全方位移動型のロボットであれば、y軸並進速度も設定されます。）
    
    座標軸の考え方は、下図の通りで、ロボット前方がx軸正方向、ロボット左方向がy軸正方向となります。z軸回転速度は、左回転が正方向です。

  * odomとbase_linkの相対位置については、TFでも全く同じ内容が通知されます。Navigationスタックは、TFで通知される位置情報を見ており、オドメトリ情報側の自己位置情報は、実際には参照されていません。
  * 位置・姿勢の共分散については、x,y,z軸位置およびx,y,z軸姿勢の6つの要素について、推定値と実際の値との掛け合わせの相関関係を、6x6の行列データとして設定します。（つまり、推定の確からしさを設定します。）
    
    通常、x軸位置とy軸位置など、異なる要素は相関関係がないため、行列の対角成分のみ値が設定され、それ以外は0となります。
    
    Navigationスタックでは、共分散情報を参照していないため、設定していなくても、Navigationスタックの動作に支障はありません。
  * 速度の共分散についても、同様に、x,y,z軸並進速度およびx,y,z軸回転速度の6つの要素について、推定値と実際の値との掛け合わせの相関関係を、6x6の行列データとして設定します。
    こちらも、Navigationスタックでは参照されていません。

.. _odom_picture:

.. image:: /images/base_local_planner_coord.png
   :align: center

メッセージ定義
------------------------------------------------------------

.. _msg_std_msgs_Header4:

std_msgs/Header

.. parsed-literal:: 

    uint32 seq       # シーケンス番号
    time stamp       # タイムスタンプ
    string frame_id  # 親フレームID（通常はodom）

.. _msg_geometry_msgs_Point:

geometry_msgs/Point

.. parsed-literal:: 

    float64 x  # x座標[m]
    float64 y  # y座標[m]
    float64 z  # z座標[m]

.. _msg_geometry_msgs_Pose:

geometry_msgs/Pose

.. parsed-literal:: 

    :ref:`geometry_msgs/Point<msg_geometry_msgs_Point>` position           # 位置
    :ref:`geometry_msgs/Quaternion<msg_geometry_msgs_Quaternion>` orientation   # 姿勢（クォータニオン）

.. _msg_geometry_msgs_PoseWithCovariance:

geometry_msgs/PoseWithCovariance

.. parsed-literal:: 

    :ref:`geometry_msgs/Pose<msg_geometry_msgs_Pose>` pose # 推定自己位置
    float64[36] covariance  # 位置・姿勢の共分散

.. _msg_geometry_msgs_Twist:

geometry_msgs/Twist

.. parsed-literal:: 

    :ref:`geometry_msgs/Vector3<msg_geometry_msgs_Vector3>` linear   # 並進速度
    :ref:`geometry_msgs/Vector3<msg_geometry_msgs_Vector3>` angular  # 回転速度

.. _msg_geometry_msgs_TwistWithCovariance:

geometry_msgs/TwistWithCovariance

.. parsed-literal:: 

    :ref:`geometry_msgs/Twist<msg_geometry_msgs_Twist>` twist  # 速度
    float64[36] covariance     # 速度の共分散

nav_msgs/Odometry

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header4>` header
    string child_frame_id                   # 子フレームID（通常はbase_link）
    :ref:`geometry_msgs/PoseWithCovariance<msg_geometry_msgs_PoseWithCovariance>` pose   # 推定自己位置
    :ref:`geometry_msgs/TwistWithCovariance<msg_geometry_msgs_TwistWithCovariance>` twist # 速度

|

地図
************************************************************

オプションとして、Navigationスタックに地図を与えることで、測距センサで見えていない後方や遠方、死角の情報も加味して経路検索を行うことができます。

地図は、OccupancyGridというデータ形式で表現します。5cm四方など、決まったサイズのセルで地図を区切り、各セルを、「占有されたセル(100)」、「占有されていないセル(0)」、「未知のセル(-1)」の3つで区分して地図を表現します。

地図情報は、解像度（セルの大きさ）、地図の大きさ（縦横のセル数）、オリジン（/map座標軸におけるセル(0,0)の位置）、そして各セルの占有率を保持した配列データから成ります。

.. image:: /images/occupancy_grid_map.png
   :align: center

メッセージ定義
------------------------------------------------------------

.. _msg_std_msgs_Header5:

std_msgs/Header

.. parsed-literal:: 

    uint32 seq       # シーケンス番号
    time stamp       # タイムスタンプ
    string frame_id  # フレームID（通常はmap）

.. _msg_nav_msgs_MapMetaData:

nav_msgs/MapMetaData

.. parsed-literal:: 

    time map_load_time          # 地図ロード時間（参照されない。header.stampと同値を入れておけばよい。）
    float32 resolution          # 地図解像度[m]
    uint32 width                # 地図横サイズ[セル数]
    uint32 height               # 地図縦サイズ[セル数]
    :ref:`geometry_msgs/Pose<msg_geometry_msgs_Pose>` origin   # オリジン座標

.. _msg_nav_msgs_OccupancyGrid:

nav_msgs/OccupancyGrid

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header5>` header
    nav_msgs/MapMetaData info   # 地図付帯情報
    int8[] data                 # 地図データ

|

駆動（速度）命令
************************************************************

安全な経路を検索した結果として、Navigationスタックから駆動命令が出力されます。

速度は、並進速度(x,y,z)および回転速度(x,y,z)で表現され、一般的な2輪差動型のロボットの場合は、x軸並進速度とz軸回転速度のみ指定されます。オムニホイールなど全方位移動型のロボットの場合は、y軸直線速度が追加で指定されます。

座標軸についての考え方は、:ref:`オドメトリ情報の現在速度<odom_picture>` と同じです。

メッセージ定義
------------------------------------------------------------


geometry_msgs/Twist

.. parsed-literal:: 

    :ref:`geometry_msgs/Vector3<msg_geometry_msgs_Vector3>` linear   # 並進速度
    :ref:`geometry_msgs/Vector3<msg_geometry_msgs_Vector3>` angular  # 回転速度

|

その他のメッセージ型
************************************************************

共分散・タイムスタンプ付き位置・姿勢
------------------------------------------------------------
オドメトリ情報と同じ共分散付き位置・姿勢データにヘッダが付与されたメッセージ型です。ロボット自己位置の初期設定等に使用されます。

.. _msg_std_msgs_Header_com:

std_msgs/Header

.. parsed-literal:: 

    uint32 seq       # シーケンス番号
    time stamp       # タイムスタンプ
    string frame_id  # フレームID

.. _msg_geometry_msgs_PoseWithCovarianceStamped:

geometry_msgs/PoseWithCovarianceStamped

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    :ref:`geometry_msgs/PoseWithCovariance<msg_geometry_msgs_PoseWithCovariance>` pose   # 位置・姿勢

|


位置・姿勢配列
------------------------------------------------------------
位置・姿勢データの配列です。パーティクル分散の視覚情報等に使用されます。

.. _msg_geometry_msgs_PoseArray:

geometry_msgs/PoseArray

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    :ref:`geometry_msgs/Pose<msg_geometry_msgs_Pose>` [] poses   # 位置・姿勢配列

|

経路情報
------------------------------------------------------------
経路情報です。位置・姿勢データの配列で表現されます。経路の視覚情報等に使用されます。

.. _msg_geometry_msgs_PoseStamped:

geometry_msgs/PoseStamped

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    :ref:`geometry_msgs/Pose<msg_geometry_msgs_Pose>` pose   # 位置・姿勢


.. _msg_nav_msgs_Path:

nav_msgs/Path

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    :ref:`geometry_msgs/PoseStamped<msg_geometry_msgs_PoseStamped>` [] poses   # 位置・姿勢配列

|


ポイントクラウド2
------------------------------------------------------------
ポイントクラウドの点群情報を、BLOBデータで表現するデータ型です。

1つのデータがどのような構成になっているかをfieldsで定義します。例えば、"x","y","z"座標が、FLOAT32(7)で1つずつ入っているといった具合です。（全部で12byte）さらに、反射強度など任意のフィールドを定義できます。
このデータが、height * width分含まれる形で、TOFカメラの出力のようなイメージのデータ形式となります。（2D画像の各ピクセルが、3D座標情報を持っているようなイメージ。）

.. _msg_sensor_msgs_PointField:

sensor_msgs/PointField

.. parsed-literal:: 

    uint8 INT8    = 1
    uint8 UINT8   = 2
    uint8 INT16   = 3
    uint8 UINT16  = 4
    uint8 INT32   = 5
    uint8 UINT32  = 6
    uint8 FLOAT32 = 7
    uint8 FLOAT64 = 8

    string name      # データ内のフィールドの名前
    uint32 offset    # このフィールドがデータ内の何バイト目から始まるか
    uint8  datatype  # このフィールドのデータ型（上記のいずれか）
    uint32 count     # このフィールドのデータ数

.. _msg_sensor_msgs_PointCloud2:

sensor_msgs/PointCloud2

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    uint32 height                     # データ配列の高さ
    uint32 width                      # データ配列の幅
    :ref:`sensor_msgs/PointField<msg_sensor_msgs_PointField>` [] fields  # フィールド定義
    bool is_bigendian                 # フィールドのデータ型がビッグエンディアンかどうか
    uint32 point_step                 # 1データのあたりのバイト数
    uint32 row_step                   # 1行あたりのバイト数(point_step * width)
    uint8[] data                      # データ(サイズはrow_step * height)
    bool is_dense                     # データがすべて有効値かどうか

|

多角形
------------------------------------------------------------
多角形の頂点座標配列です。ロボットのフットプリント表現などに使用されます。

geometry_msgs/Polygon

.. parsed-literal:: 

    :ref:`geometry_msgs/Point32<msg_geometry_msgs_Point32>` [] points         # 頂点座標配列

|

占有グリッド更新情報
------------------------------------------------------------
:ref:`nav_msgs/OccupancyGrid<msg_nav_msgs_OccupancyGrid>` のデータを部分更新するためのデータ型です。

map_msgs/OccupancyGridUpdate

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    int32 x        # 始点x座標[m]
    int32 y        # 始点y座標[m]
    uint32 width   # 幅[m]
    uint32 height  # 高さ[m]
    int8[] data    # 更新データ

|

ボクセルグリッド情報
------------------------------------------------------------
:doc:`voxel_grid <voxel_grid>` のデータを視覚表示するためのデータ型です。

3Dグリッドの高さを最大16段階とし、2Dで見た各列の占有／空きを、16ビットデータの各ビットの1/0で表現したものです。（「不明」は、全てのビットが1の列としています。）

costmap_2d/VoxelGrid

.. parsed-literal:: 

    :ref:`std_msgs/Header<msg_std_msgs_Header_com>` header
    uint32[] data                       # グリッド占有／空きデータ
    :ref:`geometry_msgs/Point32<msg_geometry_msgs_Point32>` origin        # オリジン座標
    :ref:`geometry_msgs/Vector3<msg_geometry_msgs_Vector3>` resolutions   # グリッド解像度
    uint32 size_x                       # x軸データサイズ
    uint32 size_y                       # y軸データサイズ
    uint32 size_z                       # z軸データサイズ(最大16)

|

サービス型
************************************************************

Empty型
------------------------------------------------------------
引数無し（コールのみ）のサービス型です。

std_srvs/Empty

.. parsed-literal:: 

    ---

|

地図設定
------------------------------------------------------------
地図および初期位置を引き渡すためのサービス型です。

nav_msgs/SetMap

.. parsed-literal:: 

    :ref:`nav_msgs/OccupancyGrid<msg_nav_msgs_OccupancyGrid>` map                            # 地図
    :ref:`geometry_msgs/PoseWithCovarianceStamped<msg_geometry_msgs_PoseWithCovarianceStamped>` initial_pose  # 初期位置・姿勢
    ---
    bool success                                          # 処理結果

|

地図取得
------------------------------------------------------------
地図を取得するためのサービス型です。

nav_msgs/GetMap

.. parsed-literal:: 

    ---
    :ref:`nav_msgs/OccupancyGrid<msg_nav_msgs_OccupancyGrid>` map  # 地図

|

経路取得
------------------------------------------------------------
経路を取得するためのサービス型です。

nav_msgs/GetPlan

.. parsed-literal:: 

    :ref:`geometry_msgs/PoseStamped<msg_geometry_msgs_PoseStamped>` start  # スタート位置・姿勢
    :ref:`geometry_msgs/PoseStamped<msg_geometry_msgs_PoseStamped>` goal   # ゴール位置・姿勢
    float32 tolerance                # ゴール許容誤差[m]
    ---
    :ref:`nav_msgs/Path<msg_nav_msgs_Path>` plan               # 経路

|

アクション型
************************************************************

MoveBaseアクション
------------------------------------------------------------
Navigationスタックへ、目標位置・姿勢を指定してロボットの移動を指示し、フィードバック（現在位置）および結果を受け取るためのアクションです。

MoveBase.action

.. parsed-literal:: 

    # ゴール定義
    :ref:`geometry_msgs/PoseStamped<msg_geometry_msgs_PoseStamped>` target_pose     # 目標位置・姿勢
    ---
    # 結果定義
    ---
    # フィードバック定義
    :ref:`geometry_msgs/PoseStamped<msg_geometry_msgs_PoseStamped>` base_position   # 現在位置・姿勢

|


