move_slow_and_clear
=================================================
目次
    
| 　1. :ref:`概要<move_slow_and_clear_overview>`
| 　2. :ref:`move_slow_and_clearの概要<move_slow_and_clear_move_slow_and_clear_overview>`
| 　3. :ref:`MoveSlowAndClear<move_slow_and_clear_move_slow_and_clear>`
| 　　3.1 :ref:`APIの安定性<move_slow_and_clear_api>`
| 　　3.2 :ref:`ROSパラメータ<move_slow_and_clear_ros_param>`
| 　　3.3 :ref:`C++ API<move_slow_and_clear_cpp_api>`
|

.. _move_slow_and_clear_overview:

============================================================
1. 概要
============================================================
| 　このパッケージは、:doc:`コストマップ</costmap_2d>` 内の情報をクリアし、ロボットの速度を制限する単純なリカバリ動作を提供します。
|

* 管理状態：管理済み 
* 管理者：David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Eitan Marder-Eppstein, contradict@gmail.com
* ライセンス：BSD
* ソース：git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|

.. _move_slow_and_clear_move_slow_and_clear_overview:

============================================================
2. move_slow_and_clearの概要
============================================================
| 　move_slow_and_clear::MoveSlowAndClearは、 :doc:`コストマップ</costmap_2d>` 内の情報をクリアし、ロボットの速度を制限する単純なリカバリ動作です。このリカバリ動作は真に安全ではないことに注意してください。ユーザーが指定した速度で動くだけで、ロボットが物にぶつかる可能性があります。また、このリカバリ動作は、 :doc:`dwa_local_planner</dwa_local_planner>` などの `dynamic_reconfigure <http://wiki.ros.org/dynamic_reconfigure>`_ を介して最大速度を設定できるローカルプランナーとのみ互換性があります。
|
| 　以下の手順でリカバリを行います。
|

#. グローバルコストマップとローカルコストマップのロボットの周辺のエリア（ロボットを中心とした1辺が :ref:`clearing_distance<move_slow_and_clear_ros_param>` * 2 の正方形 ）を空き（占有されていない）にします。

   .. image:: /images/move_slow_and_clear.png
      :width: 816
      :align: center

#. :ref:`planner_name_space<move_slow_and_clear_ros_param>` で示したプランナーのmax_trans_velとmax_rot_velパラメータを、:ref:`limited_trans_speed<move_slow_and_clear_ros_param>` と :ref:`limited_rot_speed<move_slow_and_clear_ros_param>` パラメータで指定した速度に更新します。
#. 0.1秒周期で、グローバルコストマップ上の移動距離をチェックします。

   * 指定した距離（ :ref:`limited_distance<move_slow_and_clear_ros_param>` ） ≦ 速度制限開始位置と現在位置の距離 : 移動距離のチェックを終了し、max_trans_velとmax_rot_velを元の速度に戻します。

|

.. _move_slow_and_clear_move_slow_and_clear:

============================================================
3. MoveSlowAndClear
============================================================
| 　move_slow_and_clear::MoveSlowAndClearオブジェクトは、その機能を `C++ ROSラッパー <http://wiki.ros.org/navigation/ROS_Wrappers>`_ として公開します。これは、初期化時に指定されたROS名前空間（以降、\ *name*\ と仮表記）内で動作します。 :doc:`nav_core</nav_core>` パッケージにあるnav_core::RecoveryBehaviorインタフェースに準拠しています。
|

.. _move_slow_and_clear_api:


3.1 APIの安定性
************************************************************

* C++ APIは安定しています。
* ROS APIは安定しています。

|

.. _move_slow_and_clear_ros_param:


3.2 ROSパラメータ
************************************************************

.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 5, 50, 5, 5, 8

   "~<name>/clearing_distance", "障害物が除去されるロボットからの半径（メートル単位）。この半径の内部の障害物がクリアされます。", "double", "m", "0.5"
   "~<name>/limited_trans_speed", "このリカバリ動作の実行中にロボットが制限される並進速度（メートル/秒単位）。", "double", "m/sec", "0.25"
   "~<name>/limited_rot_speed", "このリカバリ動作の実行中にロボットが制限される回転速度（ラジアン/秒単位）。", "double", "rad/sec", "0.45"
   "~<name>/limited_distance", "速度制限が解除される前にロボットが移動しなければならない距離（メートル単位）。", "double", "m", "0.3"
   "~<name>/planner_namespace", "パラメータを再構成するプランナーの名前。特に、max_trans_velおよびmax_rot_velパラメータは、この名前空間内で再構成されます。", "string", "－", """DWAPlannerROS"""

|

.. _move_slow_and_clear_cpp_api:


3.3 C++ API
************************************************************
| 　C ++ move_slow_and_clear::MoveSlowAndClearクラスは、 :doc:`nav_core</nav_core>` パッケージにあるnav_core::RecoveryBehaviorインタフェースに準拠しています。詳細なドキュメントについては、 `MoveSlowAndClearドキュメント <http://www.ros.org/doc/api/move_slow_and_clear/html/>`_ を参照してください。
|
