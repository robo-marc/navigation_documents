clear_costmap_recovery
===========================================
目次
    
| 　1. :ref:`概要<clear_cost_map_recovery_overview>`
| 　2. :ref:`clear_cost_map_recoveryの概要<clear_cost_map_recovery_recovery_overview>`
| 　3. :ref:`ClearCostmapRecovery<clear_cost_map_recovery_clear_cost_map_recovery>`
| 　　4.1 :ref:`APIの安定性<clear_cost_map_recovery_api>`
| 　　4.2 :ref:`ROSパラメータ<clear_cost_map_recovery_param>`
| 　　4.3 :ref:`C++ API<clear_cost_map_recovery_cpp_api>`
|

.. _clear_cost_map_recovery_overview:

============================================================
1. 概要
============================================================
| 　このパッケージは、Navigationスタックが使用するコストマップを特定の領域外の静的マップに戻すことでスペースをクリアしようとするNavigationスタックのリカバリ動作を提供します。
|

* 管理状態：管理済み 
* 管理者：David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Eitan Marder-Eppstein, contradict@gmail.com
* ライセンス：BSD
* ソース：git git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|

.. _clear_cost_map_recovery_recovery_overview:

============================================================
2. clear_cost_map_recoveryの概要
============================================================
| 　clear_costmap_recovery::ClearCostmapRecoveryは、ロボットから特定の半径の外側を静的マップに戻すことにより、Navigationスタックの :doc:`コストマップ</costmap_2d>` 内のスペースをクリアする単純なリカバリ動作です。 :doc:`nav_core</nav_core>` パッケージに含まれるnav_core::RecoveryBehaviorインタフェースに準拠しており、 :doc:`move_base</move_base>` ノードのリカバリ動作 `プラグイン <http://wiki.ros.org/pluginlib>`_ として使用できます。
|

.. image:: /images/clear_costmap_recovery_overview.png
   :height: 194
   :width: 816
   :align: center

.. _clear_cost_map_recovery_clear_cost_map_recovery:

============================================================
3. ClearCostmapRecovery
============================================================
| 　clear_costmap_recovery::ClearCostmapRecoveryオブジェクトは、その機能を `C++ ROSラッパー <http://wiki.ros.org/navigation/ROS_Wrappers>`_ として公開します。これは、初期化時に指定されたROS名前空間（以降、\ *name*\ と仮表記）内で動作します。 :doc:`nav_core</nav_core>` パッケージにあるnav_core::RecoveryBehaviorインタフェースに準拠しています。
|
| 　clear_costmap_recovery :: ClearCostmapRecoveryオブジェクトの作成例：
|

::

    #include <tf/transform_listener.h>
    #include <costmap_2d/costmap_2d_ros.h>
    #include <clear_costmap_recovery/clear_costmap_recovery.h>

    ...
    tf::TransformListener tf(ros::Duration(10));
    costmap_2d::Costmap2DROS global_costmap("global_costmap", tf);
    costmap_2d::Costmap2DROS local_costmap("local_costmap", tf);

    clear_costmap_recovery::ClearCostmapRecovery ccr;
    ccr.initialize("my_clear_costmap_recovery", &tf, &global_costmap, &local_costmap);

    ccr.runBehavior();

|

.. _clear_cost_map_recovery_api:


4.1 APIの安定性
************************************************************

* C++ API は安定しています。
* ROS API は安定しています。

|

.. _clear_cost_map_recovery_param:


4.2 ROSパラメータ
************************************************************

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~<name>/reset_distance", "ロボットの位置を中心とする正方形の辺の長さ。その外側の障害物は、静的マップに戻されたときにコストマップから削除されます。", "double", "m", "3.0"
   "~<name>/force_updating", "クリア後にコストマップの更新を強制するため、更新スレッドを待つ必要はありません。（ROSWikiに未記載のパラメータ）", "bool", "－", "false"
   "~<name>/affected_maps", "| 　""local"":ローカルのコストマップのみをクリアする。
   | 　""global"":グローバルのコストマップのみをクリアする。
   | 　""both"":両方のコストマップをクリアする。（ROSWikiに未記載のパラメータ）", "string", "－", "both"
   "~<name>/layer_names", "クリアするレイヤー名。複数指定可。（ROSWikiに未記載のパラメータ）", "vector<string>", "－", "obstacles"

|

.. _clear_cost_map_recovery_cpp_api:


4.3 C++ API
************************************************************
| 　C++ clear_costmap_recovery::ClearCostmapRecoveryクラスは、 :doc:`nav_core</nav_core>` パッケージにあるnav_core::RecoveryBehaviorインタフェースに準拠しています。詳細なドキュメントについては、 `ClearCostmapRecoveryドキュメント <https://docs.ros.org/api/clear_costmap_recovery/html/classclear__costmap__recovery_1_1ClearCostmapRecovery.html>`_ を参照してください。
|