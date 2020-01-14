map_server
=======================================
目次
    
| 　1. :ref:`概要<navigation_map_server_over_view>`
| 　2. :ref:`地図フォーマット<navigation_map_server_map_format>`
| 　　2.1 :ref:`画像フォーマット<navigation_map_server_img_format>`
| 　　2.2 :ref:`YAML形式<navigation_map_server_yaml_format>`
| 　　2.3 :ref:`値の解釈<navigation_map_server_value>`
| 　　　2.3.1 :ref:`Trinary<navigation_map_server_trinary>`
| 　　　2.3.2 :ref:`Scale<navigation_map_server_scale>`
| 　　　2.3.3 :ref:`Raw<navigation_map_server_raw>`
| 　3. :ref:`コマンドラインツール<navigation_map_server_command>`
| 　　3.1 :ref:`map_server<navigation_map_server_command_map_server>`
| 　　　3.1.1 :ref:`Usage<navigation_map_server_command_usage>`
| 　　　3.1.2 :ref:`Example<navigation_map_server__command_example>`
| 　　　3.1.3 :ref:`Published Topics<navigation_map_server_command_published>`
| 　　　3.1.4 :ref:`Services<navigation_map_server_command_service>`
| 　　　3.1.5 :ref:`パラメータ<navigation_map_server_command_param>`
| 　　3.2 :ref:`map_saver<navigation_map_server_command_map_sarver>`
| 　　　3.2.1 :ref:`Usage<navigation_map_server_command_usage2>`
| 　　　3.2.2 :ref:`Example<navigation_map_server_command_example2>`
| 　　　3.2.3 :ref:`Subscribed Topics<navigation_map_server_command_subscribed>`
|

.. _navigation_map_server_over_view:

============================================================
1. 概要
============================================================
| 　map_serverは、地図データをROSサービスとして提供するmap_server ROSノードを提供します。また、動的に生成された地図をファイルに保存できるmap_saverコマンドラインユーティリティも提供します。
|

* 管理状態：管理済み 
* 管理者：David V. Lu !! <Davidvlu AT gmail DOT com>、Michael Ferguson <mfergs7 AT gmail DOT com>、Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Brian Gerkey, Tony Pratkanis, contradict@gmail.com
* ライセンス：BSD
* ソース：git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|


.. _navigation_map_server_map_format:

============================================================
2. 地図フォーマット
============================================================
| 　このパッケージのツールで操作される地図は、1組のファイルに保存されます。YAMLファイルは、地図のメタデータを記述し、画像ファイルに名前を付けます。画像ファイルは占有データをエンコードします。
|

.. _navigation_map_server_img_format:


2.1 画像フォーマット
************************************************************
| 　地図で使用する画像は、空間の各セルの占有状態を、対応するピクセルの色で示しています。標準構成では、白いピクセルは占有されていないセル、黒いピクセルは占有されているセル、その間（グレー）のピクセルは未知のセルです。カラー画像は受け入れられますが、カラー値はグレー値に平均化されます。
|
| 　画像データは `SDL_Image <http://www.libsdl.org/projects/SDL_image/docs/index.html>`_ を介して読み込まれます。 サポートされる形式は、特定のプラットフォームでSDL_Imageが提供するものによって異なります。 一般的な画像形式は広くサポートされていますが、例外として、PNGはOS Xでサポートされていません。
|


.. _navigation_map_server_yaml_format:


2.2 YAML形式
************************************************************
| 　YAML形式は、以下の簡単な例で全て説明できます。

::

    image: testmap.png
    resolution: 0.1
    origin: [0.0, 0.0, 0.0]
    occupied_thresh: 0.65
    free_thresh: 0.196
    negate: 0

| 必須フィールド:

.. csv-table:: 
   :header: "フィールド名", "内容"
   :widths: 10, 30

   "image", "占有データを含む画像ファイルへのパス。 絶対パス、またはYAMLファイルの場所からの相対パスを設定可能。"
   "resolution", "地図の解像度（単位はm/pixel）。"
   "origin", "（x、y、yaw）のような地図の左下のピクセルからの2次元姿勢で、yawは反時計回りに回転します（yaw = 0は回転しないことを意味します）。現在、システムの多くの部分ではyawを無視しています。"
   "occupied_thresh", "この閾値よりも大きい占有確率を持つピクセルは、完全に占有されていると見なされます。"
   "free_thresh", "占有確率がこの閾値未満のピクセルは、完全に占有されていないと見なされます。"
   "negate", "白/黒について、空き/占有の意味を逆にする必要があるかどうか（閾値の解釈は影響を受けません）"

|
| オプションパラメータ

.. csv-table:: 
   :header: "オプション名", "内容"
   :widths: 10, 30

   "mode", "trinary, scale, raw の3つの値のうち、いずれかを指定できます。Trinaryがデフォルトです。これにより値の解釈がどのように変化するかについての詳細は、次のセクションで説明します。"

|

.. _navigation_map_server_value:


2.3 値の解釈
************************************************************
| 　範囲[0, 256）のCOLOR値xを持つピクセルが与えられた場合、ROSメッセージに入れるときにこの値をどのように解釈する必要があるかについて説明します。最初に、yamlのnegateフラグの解釈に応じて、整数xを浮動小数点数pに変換します。
|
| 　• negateがfalseの場合：　 p = (255 - x) / 255.0
| 　　　　これは、黒（0）が最高値（1.0）になり、白（255）が最低値（0.0）になることを意味します。
| 　• negateがtrueの場合：　p = x / 255.0
| 　　　　これは画像の非標準的な解釈です。xが否定されていないことを数学が示しているにもかかわらず、negate(否定）と呼ばれるのはこのためです。
|

.. _navigation_map_server_trinary:


2.3.1 Trinary
------------------------------------------------------------
| 　標準的な解釈は3項(Trinary)解釈です。つまり、すべての値を解釈して、出力が3つの値のいずれかになるようにします。
|
| 　• p > occupied_thresh の場合：　セルが占有されていることを示す値100を出力します。
| 　• p < free_thresh の場合：　値0を出力して、セルが占有されていないことを示します。
| 　• それ以外の場合：　-1 （unsigned charの場合 255）を出力して、セルが不明であることを示します。
|

.. _navigation_map_server_scale:


2.3.2 Scale
------------------------------------------------------------
| 　このモードは、上記の解釈を微調整して、3項よりも多くの出力値を許可します。
|
| 　• Trinaryと同様に、p > occupied_threshの場合、値100を出力します。p < free_thresh の場合、値0を出力します。
| 　• それ以外の場合：　99 * (p - free_thresh) / (occupied_thresh - free_thresh) を出力します。
|
| 　これにより、[0, 100]の範囲の値の完全な勾配を出力できます。-1を出力するには、PNGのアルファチャネルを使用します。この場合、透明度は不明と解釈されます。
|

.. _navigation_map_server_raw:


2.3.3 Raw
------------------------------------------------------------
| 　このモードは各ピクセルに対してxを出力するため、出力値は[0, 255]です。
|

.. _navigation_map_server_command:

============================================================
3. コマンドラインツール
============================================================


.. _navigation_map_server_command_map_server:


3.1 map_server
************************************************************
| 　map_serverは、ディスクから地図を読み取り、ROSサービス経由で地図を提供するROSノードです。map_serverの現在の実装は、マップイメージデータの色の値を、3つの占有値（空き（0）、占有（100）、不明（-1））に変換します。このツールの今後のバージョンでは、0〜100の値を使用して、より細かい占有率のグラデーションを伝達する可能性があります。
|

.. _navigation_map_server_command_usage:


3.1.1 Usage
------------------------------------------------------------

::

    map_server <map.yaml>

|

.. _navigation_map_server__command_example:


3.1.2 Example
------------------------------------------------------------

::

    rosrun map_server map_server mymap.yaml

| 地図データは、ラッチされたトピック（新しいサブスクライバーごとに1回送信されることを意味する）またはサービスを介して取得できることに注意してください。サービスは最終的に廃止される可能性があります。
|

.. _navigation_map_server_command_published:


3.1.3 Published Topics
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "map_metadata", "`nav_msgs/MapMetaData <http://docs.ros.org/api/nav_msgs/html/msg/MapMetaData.html>`_", "このラッチされたトピックを介して地図のメタデータを受信します。"
   "map", "`nav_msgs/OccupancyGrid <http://docs.ros.org/api/nav_msgs/html/msg/OccupancyGrid.html>`_", "このラッチされたトピックを介して地図を受信します。"

|

.. _navigation_map_server_command_service:


3.1.4 Services
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "static_map ", "`nav_msgs/GetMap <http://docs.ros.org/api/nav_msgs/html/srv/GetMap.html>`_", "このサービスを介して地図を取得します。"

|


.. _navigation_map_server_command_param:


3.1.5 パラメータ
------------------------------------------------------------

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~frame_id", "パブリッシュされた地図のヘッダーに設定するフレーム。", "string", "－", "map"

|

.. _navigation_map_server_command_map_sarver:


3.2 map_saver
************************************************************
| 　map_saverは、たとえばSLAMマッピングサービスからディスクに地図を保存します。
|

.. _navigation_map_server_command_usage2:


3.2.1 Usage
------------------------------------------------------------

::

    rosrun map_server map_saver [--occ <threshold_occupied>] [--free <threshold_free>] [-f <mapname>]

| map_saverは地図データを取得し、map.pgmおよびmap.yamlに書き込みます。-fオプションを使用して、出力ファイルに異なるベース名を指定します。--occおよび--freeオプションは、0〜100の値を取ります。
|

.. _navigation_map_server_command_example2:


3.2.2 Example
------------------------------------------------------------

::

    rosrun map_server map_saver -f mymap

|

.. _navigation_map_server_command_subscribed:


3.2.3 Subscribed Topics
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "map", "`nav_msgs/OccupancyGrid <http://docs.ros.org/api/nav_msgs/html/msg/OccupancyGrid.html>`_", "地図は、このラッチされたトピックを介して取得されます。"

|
