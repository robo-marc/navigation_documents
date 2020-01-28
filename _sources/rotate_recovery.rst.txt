rotate_recovery
============================================
目次
    
| 　1. :ref:`概要<rotate_recovery_pkgsummary>`
| 　2. :ref:`rotate_recovery概要<rotate_recovery_overview>`
| 　3. :ref:`RotateRecovery<rotate_recovery_rotate_recovery>`
| 　　3.1 :ref:`APIの安定性<rotate_recovery_api>`
| 　　3.2 :ref:`ROSパラメータ<rotate_recovery_rosparam>`
| 　　　3.2.1 :ref:`RotateRecoveryパラメータ<rotate_recovery_rotate_recovery_param>`
| 　　　3.2.2 :ref:`TrajectoryPlannerROSパラメータ<rotate_recovery_trajectory_planner_param>`
| 　　3.3 :ref:`C++ API<rotate_recovery_cpp_api>`
|

.. _rotate_recovery_pkgsummary:

============================================================
1. 概要
============================================================
| 　このパッケージは、ロボットの360度回転を実行してスペースを空にしようとするNavigationスタックのリカバリ動作を提供します。

* 管理状態：管理済み 
* 管理者：David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Eitan Marder-Eppstein, contradict@gmail.com
* ライセンス：BSD
* ソース：git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|

.. _rotate_recovery_overview:

============================================================
2. rotate_recovery概要
============================================================
| 　rotate_recovery::RotateRecoveryは、ローカルの障害物が許せばロボットを360度回転させることにより、Navigationスタックの :doc:`コストマップ</costmap_2d>` のスペースを空にしようとする単純なリカバリ動作です。 :doc:`nav_core</nav_core>` パッケージに含まれるnav_core::RecoveryBehaviorインタフェースに準拠しており、 :doc:`move_base</move_base>` ノードのリカバリ動作 `プラグイン <http://wiki.ros.org/pluginlib>`_ として使用できます。
|

.. _rotate_recovery_rotate_recovery:

============================================================
3. RotateRecovery
============================================================
| 　rotate_recovery::RotateRecoveryオブジェクトは、その機能を `C++ ROSラッパー <http://wiki.ros.org/navigation/ROS_Wrappers>`_ として公開します。これは、初期化時に指定されたROS名前空間（以降、\ *name*\ と仮表記）内で動作します。 :doc:`nav_core</nav_core>` パッケージにあるnav_core::RecoveryBehaviorインタフェースに準拠しています。
|
| 　rotate_recovery::RotateRecoveryオブジェクトの作成例：

::

    #include <tf/transform_listener.h>
    #include <costmap_2d/costmap_2d_ros.h>
    #include <rotate_recovery/rotate_recovery.h>

    ...
    tf::TransformListener tf(ros::Duration(10));
    costmap_2d::Costmap2DROS global_costmap("global_costmap", tf);
    costmap_2d::Costmap2DROS local_costmap("local_costmap", tf);

    rotate_recovery::RotateRecovery rr;
    rr.initialize("my_rotate_recovery", &tf, &global_costmap, &local_costmap);

    rr.runBehavior();

|


.. _rotate_recovery_api:


3.1 APIの安定性
************************************************************

* C++ APIは安定しています。
* ROS APIは安定しています。

|

.. _rotate_recovery_rosparam:


3.2 ROSパラメータ
************************************************************
| 　rotate_recovery::RotateRecoveryオブジェクトは、 :doc:`move_base</move_base>` ノードで使用されるローカルプランナーがbase_local_planner::TrajectoryPlannerROSであると想定し、 :doc:`base_local_planner</base_local_planner>` パッケージに記載されているパラメータをいくつか読み取ります。単独で動作しますが、これには追加のパラメータを指定する必要があります。
|

.. _rotate_recovery_rotate_recovery_param:


3.2.1 RotateRecoveryパラメータ
------------------------------------------------------------

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~<name>/sim_granularity", "インプレース回転が安全かどうかをチェックするときの障害物のチェック間の距離（ラジアン単位）。デフォルトは1度です。", "double", "rad", "0.017"
   "~<name>/frequency", "速度コマンドをモバイルベースに送信する周波数（Hz単位）。", "double", "Hz", "20.0"

|

.. _rotate_recovery_trajectory_planner_param:


3.2.2 TrajectoryPlannerROSパラメータ
------------------------------------------------------------
| 　これらのパラメーターは、base_local_planner::TrajectoryPlannerROSローカルプランナーを使用するときにすでに設定されています。 `Navigationスタック <http://wiki.ros.org/navigation>`_ で別のローカルプランナーが使用されている場合、rotate_recovery::RotateRecoveryリカバリ動作に対して明示的に設定する必要があります。
|

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~TrajectoryPlannerROS/yaw_goal_tolerance", "目標位置に到達するときのヨー/回転のコントローラーの許容値（ラジアン単位）。", "double", "rad", "0.10"
   "~TrajectoryPlannerROS/acc_lim_th", "ロボットの回転加速度制限（ラジアン/秒^2単位）", "double", "rad/sec^2", "3.2"
   "~TrajectoryPlannerROS/max_rotational_vel", "ベースに許容される最大回転速度（ラジアン/秒単位）。", "double", "rad/sec", "1.0"
   "~TrajectoryPlannerROS/min_in_place_rotational_vel", "インプレース回転を実行しながら、ベースに許可される最小回転速度（ラジアン/秒単位）。", "double", "rad/sec", "0.4"

|

.. _rotate_recovery_cpp_api:


3.3 C++ API
************************************************************
| 　C++のrotate_recovery::RotateRecoveryクラスは、 :doc:`nav_core</nav_core>` パッケージにあるnav_core::RecoveryBehaviorインタフェースに準拠しています。 詳細なドキュメントについては、 `RotateRecoveryのドキュメント <http://www.ros.org/doc/api/rotate_recovery/html/classrotate__recovery_1_1RotateRecovery.html>`_ を参照してください。
|
