fake_localization
====================================================
目次
    
| 　1. :ref:`概要<fake_localization_overview>`
| 　2. :ref:`説明<fake_localization_description>`
| 　3. :ref:`ノード<fake_localization_nodes>`
| 　　3.1 :ref:`fake_localization<fake_localization_fake_localization>`
| 　　　3.1.1 :ref:`サブスクライブトピック<fake_localization_subscribed>`
| 　　　3.1.2 :ref:`パブリッシュトピック<fake_localization_published>`
| 　　　3.1.3 :ref:`パラメータ<fake_localization_param>`
| 　　　3.1.4 :ref:`提供される tf Transforms<fake_localization_transforms>`
|

.. _fake_localization_overview:

============================================================
1. 概要
============================================================
| 　オドメトリ情報を単に転送するROSノードを提供します。
|

* 管理状態：管理済み 
* 管理者：David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Ioan A. Sucan, contradict@gmail.com
* ライセンス：BSD
* ソース：git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|

.. _fake_localization_description:

============================================================
2. 説明
============================================================
| 　fake_localizationパッケージは自己位置推定システムに代わり、 :doc:`amcl</amcl>` で使用されるROS APIのサブセットを提供する単一ノードfake_localizationを提供します。このノードは、計算コストの小さい方法で完全な自己位置推定を提供する方法として、シミュレーション中に最も頻繁に使用されます。
| 　具体的には、fake_localizationは走行距離データを、 :doc:`amcl</amcl>` によってパブリッシュされる ロボットの姿勢(amcl_pose)、パーティクル群(particlecloud)、transformのデータ(tf)に変換します。
|

.. _fake_localization_nodes:

============================================================
3. ノード
============================================================


.. _fake_localization_fake_localization:


3.1 fake_localization
************************************************************
| 　fake_localizationは自己位置推定システムの代わりに使用され、 :doc:`amcl</amcl>` で使用されるROS APIのサブセットを提供します。

.. _fake_localization_subscribed:


3.1.1 サブスクライブトピック
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "base_pose_ground_truth", "`nav_msgs/Odometry <http://docs.ros.org/api/nav_msgs/html/msg/Odometry.html>`_", "シミュレーターによってパブリッシュされたロボットの位置。"
   "initialpose", "`geometry_msgs/PoseWithCovarianceStamped <http://docs.ros.org/api/geometry_msgs/html/msg/PoseWithCovarianceStamped.html>`_", "パブリッシュされているグラウンドトゥルースソースからのカスタムオフセットを与えるために、 `rviz <http://wiki.ros.org/rviz>`_ や `nav_view <http://wiki.ros.org/nav_view>`_ などのツールを使用してfake_localizationの姿勢を設定できます。 New in 1.1.3"

|

.. _fake_localization_published:


3.1.2 パブリッシュトピック
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "amcl_pose", "geometry_msgs/PoseWithCovarianceStamped", "シミュレーターによって報告された姿勢情報をそのまま送信します。"
   "particlecloud", "geometry_msgs/PoseArray", "ロボットの姿勢を `rviz <http://wiki.ros.org/rviz>`_ および `nav_view <http://wiki.ros.org/nav_view>`_ で視覚化するために使用されるパーティクルクラウド。"

|

.. _fake_localization_param:


3.1.3 パラメータ
------------------------------------------------------------

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~odom_frame_id", "ロボットの走行距離計フレームの名前。", "string", "－", "odom"
   "~delta_x", "シミュレーター座標フレームの原点とfake_localizationによってパブリッシュされる地図座標フレーム間のxオフセット。", "double", "－", "0.0"
   "~delta_y", "シミュレーター座標フレームの原点とfake_localizationによってパブリッシュされる地図座標フレーム間のyオフセット。", "double", "－", "0.0"
   "~delta_yaw", "シミュレーター座標フレームの原点とfake_localizationによってパブリッシュされる地図座標フレーム間のyawオフセット。", "double", "－", "0.0"
   "~global_frame_id", "global_frame_id→odom_frame_id変換をtfでパブリッシュするフレーム。 New in 1.1.3", "string", "－", "/map"
   "~base_frame_id", "ロボットのベースフレーム。 New in 1.1.3", "string", "－", "base_link"
   "~transform_tolerance", "オドメトリ情報のタイムスタンプに対して、パブリッシュするtransformのタイムスタンプに加算される秒数。(ROSWikiに未記載のパラメータ)", "double", "sec", "0.1"

|

.. _fake_localization_transforms:


3.1.4 提供される tf Transforms
------------------------------------------------------------
| /map→<odom_frame_idパラメータの値>
| 　tfを介してシミュレーターから渡されます。
|
