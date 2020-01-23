obstacles
=======================================
目次
    
| 　1. :ref:`概要<obstacles_overview>`
| 　　1.1. :ref:`マークとクリア<obstacles_marking_and_clearing>`
| 　　1.2. :ref:`ROS API<obstacles_ros_api>`
| 　　　1.2.1. :ref:`サブスクライブトピック<obstacles_subscribed_topics>`
| 　　　1.2.2. :ref:`センサー管理パラメータ<obstacles_sensor_management_parameters>`
| 　　　1.2.3. :ref:`グローバルフィルタリングパラメータ<obstacles_global_filtering_parameters>`
| 　　　1.2.4. :ref:`障害物コストマッププラグイン<obstacles_obstacle_costmap_plugin>`
| 　　　1.2.5. :ref:`ボクセルコストマッププラグイン<obstacles_voxel_costmap_plugin>`
| 　2. :ref:`観測バッファ<obstacles_observation_buffer>`
| 　　2.1. :ref:`APIの安定性<obstacles_api_stability>`
| 　　2.2. :ref:`C++ API<obstacles_cpp_api>`
|

.. _obstacles_overview:

============================================================
1. 概要
============================================================
障害物レイヤーとボクセルレイヤーは、PointCloudsまたはLaserScans形式のセンサー情報を取り込みます。 障害物レイヤーは2次元で追跡しますが、ボクセルレイヤーは3次元で追跡します。


.. _obstacles_marking_and_clearing:


1.1. マークとクリア
************************************************************
コストマップはセンサーのトピックを自動的にサブスクライブし、そのトピックに従い更新します。 各センサーは、マーク（障害物情報をコストマップに挿入）、クリア（障害物情報をコストマップから削除）、またはその両方に使用されます。 クリア操作は、センサーの原点からレポートされる各観測点グリッドまで、レイトレーシングで行います。 ボクセルレイヤーを使用すると、コストマップに入力するときに、各"列"の障害物情報は、2次元で投影されます。

.. _obstacles_ros_api:


1.2. ROS API
************************************************************


.. _obstacles_subscribed_topics:


1.2.1. サブスクライブトピック
------------------------------------------------------------
.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 10, 10, 30

   "point_cloud_topic", "`sensor_msgs/PointCloud <http://docs.ros.org/api/sensor_msgs/html/msg/PointCloud.html>`__", "observation_sourcesパラメータリストにリストされている各「PointCloud」ソースについて、そのソースからの情報がコストマップの更新に使用されます。"
   "point_cloud2_topic", "`sensor_msgs/PointCloud2 <http://docs.ros.org/api/sensor_msgs/html/msg/PointCloud2.html>`__", "observation_sourcesパラメータリストにリストされている各「PointCloud2」ソースについて、そのソースからの情報がコストマップの更新に使用されます。"
   "laser_scan_topic", "`sensor_msgs/LaserScan <http://docs.ros.org/api/sensor_msgs/html/msg/LaserScan.html>`__", "observation_sourcesパラメータリストにリストされている各「LaserScan」ソースについて、そのソースからの情報がコストマップの更新に使用されます。"
   "map", "`nav_msgs/OccupancyGrid <http://docs.ros.org/api/nav_msgs/html/msg/OccupancyGrid.html>`__", "コストマップには、ユーザー生成の静的マップから初期化するオプションがあります（ :ref:`static_map <staticmap_parameters>` パラメータを参照）。 このオプションが選択されている場合、コストマップはこのマップを取得するために :doc:`map_server <map_server>` のサービスを使用します。"

|



.. _obstacles_sensor_management_parameters:


1.2.2. センサー管理パラメータ
------------------------------------------------------------
.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "~<name>/observation_sources", "スペースで区切られた観測ソース名のリスト。これにより、以下で定義される各<source_name>名前空間が定義されます。", "string", "\-", " """" "

|

observation_sourcesの各source_nameは、パラメータを設定できる名前空間を定義します。

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "~<name>/<source_name>/topic", "このソースのセンサーデータが入力されるトピック。デフォルトはソースの名前です。", "string", "\-", "source_name"
   "~<name>/<source_name>/sensor_frame", "センサーの原点のフレーム。空のままにして、センサーデータからフレームを読み取ろうとします。フレームは、sensor_msgs / LaserScan、sensor_msgs / PointCloud、sensor_msgs / PointCloud2メッセージから読み取ることができます。", "string", "\-", ""
   "~<name>/<source_name>/observation_persistence", "各センサーの読み取りを保持する時間。 0.0の値は、最新の読み取り値のみを保持します。", "double", "s", "0.0"
   "~<name>/<source_name>/expected_update_rate", "期待されるセンサーからの読み取り時間間隔。値を0.0にすると、読み取りと読み取りの間の時間が無限になります。このパラメータは、センサーが故障したときに `navigationスタック <http://wiki.ros.org/navigation>`__ がロボットに命令しないようにするフェールセーフとして使用されます。センサーの実際の速度よりわずかに許容性の高い値に設定する必要があります。たとえば、0.05秒ごとにレーザーからのスキャンが予想される場合、このパラメータを0.1秒に設定して、十分なバッファーを確保し、ある程度のシステムレイテンシを考慮できます。", "double", "s", "0.0"
   "~<name>/<source_name>/data_type", "トピックに関連付けられているデータ型。現在、「PointCloud」、「PointCloud2」、「LaserScan」のみがサポートされています。", "string", "\-", "PointCloud"
   "~<name>/<source_name>/clearing", "この観測を使用して空き領域をクリアするかどうか。", "bool", "\-", "false"
   "~<name>/<source_name>/marking", "この観測を障害物のマークに使用するかどうか。", "bool", "\-", "true"
   "~<name>/<source_name>/max_obstacle_height", "有効と見なされるセンサーが読み取る高さの最大値。これは通常、ロボットの高さよりわずかに高く設定されます。このパラメータをグローバルなmax_obstacle_heightパラメータより大きい値に設定しても効果はありません。このパラメータをグローバルなmax_obstacle_heightよりも小さい値に設定すると、この高さより上にあるこのセンサーからのポイントが除外されます。", "double", "m", "2.0"
   "~<name>/<source_name>/min_obstacle_height", "有効と見なされるセンサーが読み取る高さの最小値。通常、これは地面の高さに設定されますが、センサーのノイズモデルに基づいて高め又は低めに設定できます。", "double", "m", "0.0"
   "~<name>/<source_name>/obstacle_range", "センサーデータを使用してコストマップに障害物を挿入する範囲の最大値。", "double", "m", "2.5"
   "~<name>/<source_name>/raytrace_range", "センサーデータを使用してマップから障害物をレイトレースする範囲の最大値。", "double", "m", "3.0"
   "~<name>/<source_name>/inf_is_valid", "「LaserScan」観測メッセージのInf値を許可します。 Inf値は、LaserScan範囲の最大値に変換されます。", "bool", "\-", "false"

|




.. _obstacles_global_filtering_parameters:


1.2.3. グローバルフィルタリングパラメータ
------------------------------------------------------------

これらのパラメータはすべてのセンサーに適用されます。

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "~<name>/max_obstacle_height", "コストマップに挿入される障害物の最大の高さ。 このパラメータは、ロボットの高さよりわずかに高く設定する必要があります。", "double", "m", "2.0"
   "~<name>/obstacle_range", "障害物がコストマップに挿入されるロボットからのデフォルトの最大距離。 これは、センサーごとに上書きできます。", "double", "m", "2.5"
   "~<name>/raytrace_range", "センサーデータを使用してマップから障害物をレイトレースするデフォルトの範囲。 これは、センサーごとに上書きできます。", "double", "m", "3.0"

|


.. _obstacles_obstacle_costmap_plugin:


1.2.4. 障害物コストマッププラグイン
------------------------------------------------------------

これらのパラメータは、ObstacleCostmapPluginによって使用されます。

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "~<name>/track_unknown_space", "falseの場合、各ピクセルには、致命的障害物または空きの2つの状態のいずれかがあります。 trueの場合、各ピクセルには、致命的障害物、空き、未知スペースの3つの状態のいずれかがあります。", "bool", "\-", "false"
   "~<name>/footprint_clearing_enabled", "trueの場合、ロボットのフットプリントにより、ロボットが通ったスペースがクリアされます（空きとしてマークされます）。", "bool", "\-", "true"
   "~<name>/combination_method", "obstacle_layerが、その向こうのレイヤーから入ってきたデータの処理方法を変更します。設定可能な値は、Overwrite（0）、Maximum（1）、Nothing（99）です。 Overwriteは、単にコストマップのデータをobstacle_layerの値で上書きします。つまり、コストマップのデータは使用されません。 Maximumは、obstacle_layerの値とコストマップの値の大きい方を取ります。ほとんどの場合は、この設定を使用します。 Nothingはコストマップを全く変更しません。これは、track_unkown_spaceの設定に依存し、コストマップの動作に大きく影響することに注意してください。", "enum", "\-", "1"

combination_methodおよびtrack_unknown_spaceパラメータの影響に関する議論については、この関連する議論のROSの回答をご覧ください： `https://answers.ros.org/question/316191 <https://answers.ros.org/question/316191>`__

|


.. _obstacles_voxel_costmap_plugin:


1.2.5. ボクセルコストマッププラグイン
------------------------------------------------------------
次のパラメータは、VoxelCostmapPluginによって使用されます。

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "~<name>/origin_z", "マップのz原点。", "double", "m", "0.0"
   "~<name>/z_resolution", "マップのz解像度。", "double", "m/cell", "0.2"
   "~<name>/z_voxels", "各""列""のボクセル数、グリッドの高さはz_resolution * z_voxelsです。", "int", "\-", "10"
   "~<name>/unknown_threshold", "「既知」と見なされる""列""で許容される未知のセルの数。", "int", "\-", "~<name>/z_voxels"
   "~<name>/mark_threshold", "「空き」と見なされる""列""で許容されるマークされたセルの最大数。", "int", "\-", "0"
   "~<name>/publish_voxel_map", "可視化のために、基礎となるボクセルグリッドをパブリッシュするかどうか。", "bool", "\-", "false"
   "~<name>/footprint_clearing_enabled", "trueの場合、ロボットのフットプリントにより、ロボットが通ったスペースがクリアされます（空きとしてマークされます）。", "bool", "\-", "true"

|


.. _obstacles_observation_buffer:

============================================================
2. 観測バッファ
============================================================
costmap_2d :: ObservationBufferは、センサーから点群を取り込み、 `tf <http://wiki.ros.org/tf>`__ を使用して目的の座標フレームに変換し、要求されるまで保存します。 ほとんどのユーザーは、costmap_2d :: ObservationBuffersの作成をcostmap_2d :: Costmap2DROSオブジェクトによって自動的に処理しますが、特別なニーズを持つユーザーは独自の作成を選択できます。


.. _obstacles_api_stability:


2.1. APIの安定性
************************************************************
C ++ APIは安定しています。


.. _obstacles_cpp_api:


2.2. C++ API
************************************************************
costmap_2d :: ObservationBufferクラスのC ++レベルのAPIドキュメントについては、次のページを参照してください： `ObservationBuffer C ++ API <http://ros.org/doc/api/costmap_2d/html/classcostmap__2d_1_1ObservationBuffer.html>`__

|

