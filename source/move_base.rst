move_base
==============================================
目次
    
| 　1. :ref:`概要<move_base_overview>`
| 　2. :ref:`ノード<move_base_nodes>`
| 　　2.1 :ref:`move_base<move_base_move_base>`
| 　　　2.1.1 :ref:`期待されるロボットの振る舞い<move_base_behavior>`
| 　　　2.1.2 :ref:`Action API<move_base_action_api>`
| 　　　　2.1.2.1 :ref:`Action Subscribed Topics<move_base_action_subs>`
| 　　　　2.1.2.2 :ref:`Action Published Topics<move_base_action_pub>`
| 　　　2.1.3 :ref:`Subscribed Topics<move_base_subs>`
| 　　　2.1.4 :ref:`Published Topics<move_base_pub>`
| 　　　2.1.5 :ref:`Services<move_base_service>`
| 　　　2.1.6 :ref:`パラメータ<move_base_param>`
| 　　　2.1.7 :ref:`コンポーネントAPI<move_base_component_api>`
|

.. _move_base_overview:

============================================================
1. 概要
============================================================
| 　move_baseパッケージは、空間上の目標位置が与えられると、モバイルベースで到達を試みるアクション（ `actionlibパッケージ <http://www.ros.org/wiki/actionlib>`_ を参照）の実装を提供します。move_baseノードは、グローバルプランナーとローカルプランナーをリンクして、グローバルナビゲーションタスクを実行します。 :doc:`nav_core</nav_core>` パッケージで指定されたnav_core::BaseGlobalPlannerインタフェースに準拠するグローバルプランナー、および :doc:`nav_core</nav_core>` パッケージに指定されたnav_core::BaseLocalPlannerインタフェースに準拠するローカルプランナーをサポートします。move_baseノードは、ナビゲーションタスクを実行するために使用される2つのコストマップも保持します。1つはグローバルプランナー用、もう1つはローカルプランナー用です（ :doc:`costmap_2d</costmap_2d>` パッケージを参照）。
|

* 管理状態：管理済み 
* 管理者：David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Eitan Marder-Eppstein, contradict@gmail.com
* ライセンス：BSD
* ソース：git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|
| Note: move_baseパッケージを使用すると、Navigationスタックを使用してロボットを目的の位置に移動できます。走行距離計フレームでPR2ロボットを動かしたいだけであれば、このチュートリアルを参照してください： `pr2_controllers/Tutorials/ 走行距離計と変換情報でのベースコントローラーの使用 <http://wiki.ros.org/pr2_controllers/Tutorials/Using%20the%20base%20controller%20with%20odometry%20and%20transform%20information>`_
|

.. _move_base_nodes:

============================================================
2. ノード
============================================================
| 　このパッケージは、 `Navigationスタック <http://wiki.ros.org/ja/navigation>`_ の主要なコンポーネントであるmove_base ROSノードを提供します。そのノードと構成オプションの詳細について以下で説明します。
|

.. _move_base_move_base:


2.1 move_base
************************************************************

.. image:: /images/navigation_overview_tf_small.png
   :width: 780
   :align: center

出典: http://wiki.ros.org/move_base

|
| 　move_baseノードは、ロボット上のNavigationスタックを構成、実行し、Navigationスタックと他のコンポーネントが対話するためのROSインタフェースを提供します。move_baseノードと他のコンポーネントとの相互作用の概要を上に示します。青色はロボットプラットフォームによって異なり、灰色はオプションですがすべてのシステムに提供されます。白いノードは必須で、すべてのシステムに提供されます。move_baseノードの構成およびNavigationスタック全体の詳細については、 `ナビゲーションのセットアップと構成のチュートリアル <http://wiki.ros.org/ja/navigation/Tutorials/RobotSetup>`_ を参照してください。
| 　move_base内の各ノードについての説明を下表に示します。
|

.. csv-table:: 
   :header: "ノード名", "説明"
   :widths: 5, 50

   "global_costmap
   local_costmap", "測距センサおよび地図から得られる障害物の配置状況から、ロボットの大きさを加味して、OccupancyGrid形式で各セルにおける移動の自由度を表現したものです。大域のglobal_costmapと狭域のlocal_costmapの2つが用いられます。global_costmapのグローバルフレーム名は :ref:`global_costmap/global_frame<move_base_param>` で、ロボットのベースリンクのフレーム名は :ref:`global_costmap/robot_base_frame<move_base_param>` パラメータで設定されます。"
   "global_planner", "global_costmapを使用して、ゴールまでの大域経路探索を行います。Plug-in APIが規定されており、任意の経路探索アルゴリズムを実装して使用することが可能です。デフォルトではnavigationパッケージに含まれるnavfnが使用されます。グローバルプランナーのプラグイン名は :ref:`base_global_planner<move_base_param>` パラメータで設定されます。"
   "local_planner", "大域経路とlocal_costmapから、狭域の経路を探索して駆動命令を出力します。Plug-in APIで入れ替え可能です。デフォルトではnavigationパッケージに含まれるbase_local_plannerが使用されます。ローカルプランナーのプラグイン名は :ref:`base_local_planner<move_base_param>` パラメータで設定されます。"
   "recovery_behaviors", "ロボットがスタックした場合に、コストマップをいったんクリーンにするなどのリカバリ動作を行い、有効な経路の可能性を探るための機能です。Plug-in APIで入れ替え可能です。デフォルトではnavigationパッケージに含まれるclear_costmap_recoveryおよびrotate_recoveryが使用されます。リカバリ動作プラグインのリストは :ref:`recovery_behaviors<move_base_param>` パラメータで設定されます。"

|

.. image:: /images/move_base_state.png
   :width: 554
   :align: center

| 　move_baseは、上に示す状態遷移をします。各状態の説明を下表に示します。

.. csv-table:: 
   :header: "状態名", "説明"
   :widths: 5, 50

   "PLANNING", "Navigationスタックにゴールが設定され、最初の大域経路を探索している状態です。大域経路探索に成功すると、CONTROLLING状態へ遷移します。大域経路探索は、CONTROLLING状態においても周期的に実行され、大域経路は都度更新されます。周期は :ref:`planner_frequency<move_base_param>` パラメータで設定されますが、このパラメータが0の場合は周期実行を行いません。
   また、大域経路探索が成功しないまま一定時間（ :ref:`planner_patience<move_base_param>` ）経過するか、大域経路探索のリトライ回数（ :ref:`max_planning_retries<move_base_param>` ）を超えると、CLEARING状態へ遷移します。"
   "CONTROLLING", "local_plannerを呼び出して最適な駆動命令を計算し、Base Controllerへ駆動命令を通知することを、周期的に繰り返している状態です。周期は :ref:`controller_frequency<move_base_param>` パラメータで設定されます。
   また、一定時間（ :ref:`controller_patience<move_base_param>` ）有効なコントロールを受信出来ないと、CLEARING状態へ遷移します。"
   "CLEARING", "ロボットのスタックを検知し、リカバリ処理を実行している状態です。"

|

.. _move_base_behavior:


2.1.1 期待されるロボットの振る舞い
------------------------------------------------------------
|

.. image:: /images/move_base_recovery_behaviors.png
   :width: 711
   :align: center

出典: http://wiki.ros.org/move_base

|
| 　適切に設定されたロボットでmove_baseノードを実行すると（詳細については `Navigationスタックのドキュメント <http://wiki.ros.org/ja/navigation>`_ を参照してください）、ロボットは、ユーザーが指定した許容範囲内を基礎として目標姿勢を達成しようとします。動的な障害物がない場合、move_baseノードは最終的に目標位置の範囲内に到達するか、失敗をユーザーに通知します。ロボットがスタックしていると認識した場合、move_baseノードはオプションでリカバリ動作を実行できます。デフォルトでは、 :doc:`move_base</move_base>` ノードは次のアクションを実行してスペースを空けようとします。
|
| 　まず、ユーザーが指定した領域外の障害物がロボットの地図からクリアされます。次に、可能であれば、ロボットはインプレース回転を実行してスペースを空にします。これも失敗すると、ロボットは地図をより積極的にクリアし、所定の位置で回転できる長方形領域の外側にあるすべての障害物を取り除きます。これに続いて、別のインプレース回転を続けます。これがすべて失敗した場合、ロボットはその目標位置への移動を実行不可能と見なし、中止したことをユーザーに通知します。これらのリカバリ動作は、 :ref:`recovery_behaviors<move_base_param>` パラメーターを使用して構成でき、 :ref:`recovery_behavior_enabled<move_base_param>` パラメーターを使用して無効にできます。
|
| 　デフォルトでの具体的な動作は、以下の流れになります。
|

#. ロボットが、一定時間( :ref:`oscillation_timeout<move_base_param>` )の間、一定の距離( :ref:`oscillation_distance<move_base_param>` )以上を移動できなかった場合は、ロボットがスタックしたとみなして、ローカルプランナーによる駆動命令演算を一時停止して、リカバリ制御を起動します。
#. 上記の4つのリカバリ処理が起動されます。リカバリ制御を1つ行うごとに、ローカルプランナーによる駆動命令演算に戻して再度移動を試み、やはり一定時間( :ref:`oscillation_timeout<move_base_param>` )一定距離( :ref:`oscillation_distance<move_base_param>` )を移動できなかった場合は、次のリカバリ処理を起動します。

   * Conservative ResetおよびAggressive Resetは、ClearCostmapRecoveryモジュールをコールして、ロボットから一定の距離以上離れたコストマップをいったんクリアする処理です。Conservativeではユーザー設定値（ :ref:`conservative_reset_dist_<move_base_param>` パラメータで設定。デフォルト：3m）、Aggressiveではロボット外接円半径（ :ref:`local_costmap/circumscribed_radius<move_base_param>` ）の4倍の範囲の外側がクリアされます。
   * Clearing Rotationは、RotateRecoveryモジュールをコールして、ロボットを360度回転させる処理です。
   * つまり、ClearCostmapとRotateを組み合わせて、「周りをもう一度よく見てみる」という動作を行います。

#. 4つのリカバリ処理を実行後も、やはり一定時間( :ref:`oscillation_timeout<move_base_param>` )一定距離 :ref:`oscillation_distance<move_base_param>` )を移動できなかった場合は、自律移動処理を途中終了します。

|


.. _move_base_action_api:


2.1.2 Action API
------------------------------------------------------------
| 　move_baseノードは、SimpleActionServerの実装を提供し（ `actionlibのドキュメント <http://wiki.ros.org/actionlib>`_ を参照）、geometry_msgs/PoseStampedメッセージを含む goal を取り込みます。ROSを介してmove_baseノードと直接通信できますが、ステータスの追跡が必要な場合は、SimpleActionClientを使用してmove_baseに goal を送信することをお勧めします。詳細については、 `actionlibのドキュメント <http://wiki.ros.org/actionlib>`_ を参照してください。

.. _move_base_action_subs:


2.1.2.1 Action Subscribed Topics
############################################################

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "move_base/goal", "`move_base_msgs/MoveBaseActionGoal <http://docs.ros.org/fuerte/api/move_base_msgs/html/msg/MoveBaseActionGoal.html>`_", "move_baseが空間上で目指す目標位置。"
   "move_base/cancel", "`actionlib_msgs/GoalID <http://docs.ros.org/api/actionlib_msgs/html/msg/GoalID.html>`_", "特定の目標位置をキャンセルする要求。"

|

.. _move_base_action_pub:


2.1.2.2 Action Published Topics
############################################################

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "move_base/feedback", "`move_base_msgs/MoveBaseActionFeedback <http://docs.ros.org/fuerte/api/move_base_msgs/html/msg/MoveBaseActionFeedback.html>`_", "フィードバックには、空間上のベースの現在位置が含まれています。"
   "move_base/status", "`actionlib_msgs/GoalStatusArray <http://docs.ros.org/api/actionlib_msgs/html/msg/GoalStatusArray.html>`_", "move_baseアクションに送信される目標のステータス情報を提供します。"
   "move_base/result", "`move_base_msgs/MoveBaseActionResult <http://docs.ros.org/fuerte/api/move_base_msgs/html/msg/MoveBaseActionResult.html>`_", "move_baseアクションの結果は空です。"

|

.. _move_base_subs:


2.1.3 Subscribed Topics
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "move_base_simple/goal", "`geometry_msgs/PoseStamped <http://docs.ros.org/api/geometry_msgs/html/msg/PoseStamped.html>`_", "目標の実行ステータスの追跡をしないユーザーに、move_baseへの非アクションインターフェイスを提供します。"

|

.. _move_base_pub:


2.1.4 Published Topics
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "cmd_vel", "`geometry_msgs/Twist <http://docs.ros.org/api/geometry_msgs/html/msg/Twist.html>`_", "モバイルベースによる実行を目的とした速度コマンドのストリーム。"

|

.. _move_base_service:


2.1.5 Services
------------------------------------------------------------

.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 5, 10, 30

   "~make_plan", "`nav_msgs/GetPlan <http://docs.ros.org/api/nav_msgs/html/srv/GetPlan.html>`_", "move_baseがその計画を実行することなしに、外部ユーザーがmove_baseから特定の姿勢への計画を要求することを許可します。"
   "~clear_unknown_space", "`std_srvs/Empty <http://docs.ros.org/api/std_srvs/html/srv/Empty.html>`_", "外部ユーザーがmove_baseにロボットの周囲の領域の不明なスペースをクリアするように指示することを許可します。これは、move_baseのコストマップを長期間停止してから、環境内の新しい場所で再び開始する場合に便利です。 - Available in versions from 1.1.0-groovy"
   "~clear_costmaps", "`std_srvs/Empty <http://docs.ros.org/api/std_srvs/html/srv/Empty.html>`_", "外部ユーザーがmove_baseが使用するコストマップ内の障害をクリアするように指示することを許可します。これにより、ロボットが物にぶつかる可能性があるため、注意して使用する必要があります。 - New in 1.3.1"

|

.. _move_base_param:


2.1.6 パラメータ
------------------------------------------------------------

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~base_global_planner", "move_baseで使用するグローバルプランナーのプラグインの名前。プラグインの詳細については、 `pluginlib <http://wiki.ros.org/pluginlib>`_ のドキュメントを参照してください。このプラグインは、 :doc:`nav_core</nav_core>` パッケージで指定されたnav_core::BaseGlobalPlannerインタフェースに準拠する必要があります。 (1.0 series default: ""NavfnROS"")", "string", "－", """navfn/NavfnROS"" For 1.1+ series"
   "~base_local_planner", "move_baseで使用するローカルプランナーのプラグインの名前。プラグインの詳細について `pluginlib <http://wiki.ros.org/pluginlib>`_ のドキュメントを参照してください。このプラグインは、 :doc:`nav_core</nav_core>` パッケージで指定されたnav_core::BaseLocalPlannerインタフェースに準拠する必要があります。 (1.0 series default: ""TrajectoryPlannerROS"")", "string", "－", """base_local_planner/TrajectoryPlannerROS"" For 1.1+ series"
   "~recovery_behaviors", "move_baseで使用するリカバリ動作プラグインのリスト。プラグインの詳細については、 `pluginlib <http://wiki.ros.org/pluginlib>`_ のドキュメントを参照してください。これらの動作は、move_baseが指定された順序で有効なプランを見つけられなかった場合に実行されます。各動作が完了すると、move_baseは計画を立てようとします。計画が成功した場合、move_baseは通常の操作を続行します。それ以外の場合は、リスト内の次のリカバリ動作が実行されます。これらのプラグインは、 :doc:`nav_core</nav_core>` パッケージで指定されたnav_core :: RecoveryBehaviorインタフェースに準拠する必要があります。 (1.0 series default: [{name: conservative_reset, type: ClearCostmapRecovery}, {name: rotate_recovery, type: RotateRecovery}, {name: aggressive_reset, type: ClearCostmapRecovery}]). 注：デフォルトのパラメータの場合、aggressive_reset動作は4 \*~/local_costmap/circumscribed_radiusの距離までクリアされます。", "list", "－", "[{name: conservative_reset, type: clear_costmap_recovery/ClearCostmapRecovery}, {name: rotate_recovery, type: rotate_recovery/RotateRecovery}, {name: aggressive_reset, type: clear_costmap_recovery/ClearCostmapRecovery}] For 1.1+ series"
   "~controller_frequency", "制御ループを実行し、速度コマンドをベースに送信する周期（Hz単位）。", "double", "Hz", "20.0"
   "~planner_patience", "プランナーが有効なプランを見つけられない時に、スペースクリアリング操作が実行されるまでの待機時間（秒単位）。", "double", "sec", "5.0"
   "~controller_patience", "コントローラーが有効なコントロールを受信しない時に、スペースクリアリング操作が実行されるまでの待機時間（秒単位）。", "double", "sec", "15.0"
   "~conservative_reset_dist", "地図内のスペースをクリアしようとするときに、 :doc:`コストマップ</costmap_2d>` から障害物がクリアされるロボットからの距離（メートル単位）。このパラメータは、move_baseにデフォルトのリカバリ動作が使用される場合にのみ使用されることに注意してください。", "double", "m", "3.0"
   "~recovery_behavior_enabled", "スペースを空けるためのmove_baseリカバリ動作を有効にするかどうか。", "bool", "－", "true"
   "~clearing_rotation_allowed", "ロボットがスペースを空にするときにインプレース回転を試みるかどうかを決定します。注：このパラメーターは、デフォルトのリカバリ動作が使用されている場合にのみ使用されます。つまり、ユーザーがrecovery_behaviorsパラメーターをカスタムに設定していないことを意味します。", "bool", "－", "true"
   "~shutdown_costmaps", "move_baseが非アクティブ状態のときにノードのコストマップをシャットダウンするかどうかを決定します。このパラメータをtrueに設定すると、アクティブ状態のとき（目標を与えられてから目標に到達するまで）にのみコストマップをセンサーからの情報で更新します。", "bool", "－", "false"
   "~oscillation_timeout", "スタック状態（有効な座標移動がない状態）になってから、リカバリ動作を実行するまでの時間（秒単位）。値0.0は、タイムアウト無し（無限待ち）になります。New in navigation 1.3.1", "double", "sec", "0.0"
   "~oscillation_distance", "スタック状態（有効な座標移動がない状態）ではないと見なされるためにロボットが移動しなければならない距離（メートル単位）。ここまで移動すると、タイマーのカウントがoscillation_timeoutまでリセットされます。 New in navigation 1.3.1", "double", "m", "0.5"
   "~planner_frequency", "グローバルプランニングループを実行する周期（Hz単位）。頻度が0.0に設定されている場合、グローバルプランナーは、新しい目標が受信されるか、ローカルプランナーがその経路がブロックされていると報告したときにのみ実行されます。New in navigation 1.6.0", "double", "Hz", "0.0"
   "~max_planning_retries", "リカバリ動作を実行する前に計画を再試行できる回数。-1.0の値は、無限に再試行します。", "int32_t", "－", "-1"
   "~clearing_radius", "プランナーが使用するコストマップの更新時に、この半径の円に外接する矩形の領域をクリアします。(ROSWikiに未記載のパラメータ)", "double", "m", "~local_costmap/circumscribed_radiusで設定された値"

|

.. _move_base_component_api:


2.1.7 コンポーネントAPI
------------------------------------------------------------
| 　move_baseノードには、独自のROS APIを持つコンポーネントが含まれています。これらのコンポーネントは、それぞれ~base_global_planner、~base_local_planner、および~recovery_behaviorsの値に基づいて異なる場合があります。デフォルトコンポーネントのAPIへのリンクは以下にあります。
|

* :doc:`costmap_2d</costmap_2d>` - move_baseで使用している :doc:`costmap_2d</costmap_2d>` パッケージに関するドキュメント。
* :doc:`nav_core</nav_core>` - move_baseで使用される nav_core::BaseGlobalPlanner と nav_core::BaseLocalPlanner インタフェースに関するドキュメント。
* :doc:`base_local_planner</base_local_planner>` - move_baseで使用している :doc:`base_local_planner</base_local_planner>` に関するドキュメント。
* :doc:`navfn</navfn>` - move_baseで使用している :doc:`navfn</navfn>` グローバルプランナーに関するドキュメント。
* :doc:`clear_costmap_recovery</clear_costmap_recovery>` - move_baseで使用している :doc:`clear_costmap_recovery</clear_costmap_recovery>` リカバリ動作に関するドキュメント。
* :doc:`rotate_recovery</rotate_recovery>` - move_baseで使用している :doc:`rotate_recovery</rotate_recovery>` リカバリ動作に関するドキュメント。

|
| 　クラス図を下に示す。

.. image:: /images/move_base_class.png
   :width: 953
   :align: center

|