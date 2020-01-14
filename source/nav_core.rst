nav_core
=======================================
目次
    
| 　1. :ref:`概要<nav_core_overview>`
| 　2. :ref:`nav_coreの概要<nav_core_nav_core_overview>`
| 　3. :ref:`BaseGlobalPlanner<nav_core_base_global_planner>`
| 　　3.1 :ref:`APIの安定性<nav_core_base_global_planner_api>`
| 　　3.2 :ref:`BaseGlobalPlanner C++ API<nav_core_base_global_planner_cpp_api>`
| 　4. :ref:`BaseLocalPlanner<nav_core_base_local_planner>`
| 　　4.1 :ref:`APIの安定性<nav_core_base_local_planner_api>`
| 　　4.2 :ref:`BaseLocalPlanner C++ API<nav_core_base_local_planner_cpp_api>`
| 　5. :ref:`RecoveryBehavior<nav_core_recovery>`
| 　　5.1 :ref:`APIの安定性<nav_core_recovery_api>`
| 　　5.2 :ref:`RecoveryBehavior C++ API<nav_core_recovery_cpp_api>`
|

.. _nav_core_overview:

============================================================
1. 概要
============================================================
| 　このパッケージは、ナビゲーション固有のロボット動作の共通インタフェースを提供します。 現在、このパッケージはBaseGlobalPlanner、BaseLocalPlanner、RecoveryBehaviorインタフェースを提供します。これらのインタフェースを使用して、同じインタフェースに準拠する新しいバージョンのプランナー、ローカルコントローラー、またはリカバリ動作を簡単に交換できるアクションを構築できます。
|

* 管理状態：管理済み 
* 管理者：David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者：Eitan Marder-Eppstein, contradict@gmail.com
* ライセンス：BSD
* ソース：git https://github.com/ros-planning/navigation.git (branch: melodic-devel)

|


.. _nav_core_nav_core_overview:

============================================================
2. nav_coreの概要
============================================================
| 　nav_coreパッケージには、Navigationスタックの主要なインタフェースが含まれています。 :doc:`move_base</move_base>` ノードで `プラグイン <http://wiki.ros.org/pluginlib>`_ として使用する全てのプランナーとリカバリ動作は、これらのインタフェースに従う必要があります。
|

.. image:: /images/nav_core_move_base_interfaces.png
   :height: 578
   :width: 673
   :align: center

.. _nav_core_base_global_planner:

============================================================
3. BaseGlobalPlanner
============================================================
| 　nav_core::BaseGlobalPlannerは、ナビゲーションで使用されるグローバルプランナーのためのインタフェースを提供します。 :doc:`move_base</move_base>` ノードのプラグインとして記述されたすべてのグローバルプランナーは、このインタフェースに従う必要があります。nav_core::BaseGlobalPlannerインタフェースを使用する現在のグローバルプランナーは次のとおりです。
|

* :doc:`global_planner</global_planner>` - navfnのより柔軟な代替として構築された、高速で補間されたグローバルプランナー。（pluginlib名： "global_planner/GlobalPlanner"）
* :doc:`navfn</navfn>` - ナビゲーション機能を使用してロボットのパスを計算するグリッドベースのグローバルプランナー。（pluginlib名： "navfn/NavfnROS"） 
* :doc:`carrot_planner</carrot_planner>` - ユーザー指定の目標点を取得し、その目標点が障害物にある場合でも、ロボットをできるだけ近くに移動しようとする単純なグローバルプランナー。（pluginlib名： "carrot_planner/CarrotPlanner"）

|

.. _nav_core_base_global_planner_api:


3.1 APIの安定性
************************************************************
| 　C++ API が安定しています。
|

.. _nav_core_base_global_planner_cpp_api:


3.2 BaseGlobalPlanner C++ API
************************************************************
| 　nav_core :: BaseGlobalPlannerのC ++ APIに関するドキュメントは、 `BaseGlobalPlannerのドキュメント <http://www.ros.org/doc/api/nav_core/html/classnav__core_1_1BaseGlobalPlanner.html>`_ にあります。
|

.. _nav_core_base_local_planner:

============================================================
4. BaseLocalPlanner
============================================================
| 　nav_core :: BaseLocalPlannerは、ナビゲーションで使用されるローカルプランナーのためのインタフェースを提供します。 :doc:`move_base</move_base>` ノードのプラグインとして記述されたすべてのローカルプランナーは、このインタフェースに従う必要があります。nav_core :: BaseLocalPlannerインターフェースを使用する現在のローカルプランナーは次のとおりです。
|

* :doc:`base_local_planner</base_local_planner>` - ローカルコントロールへの Dynamic Window Approach（DWA）およびTrajectory Rollout Approachの実装を提供します。
* :doc:`dwa_local_planner</dwa_local_planner>` - :doc:`base_local_planner</base_local_planner>` のDWAよりもクリーンで理解しやすいインタフェースを備え、より柔軟性の高いホロノミックロボット用のy軸変数を備えたモジュール式DWA実装です。
* `eband_local_planner <http://wiki.ros.org/eband_local_planner>`_ - SE2マニホールドでのElastic Bandメソッドを実装します。
* `teb_local_planner <http://wiki.ros.org/teb_local_planner>`_ - オンライン軌道最適化のためのTimed-Elastic-Bandメソッドを実装します。

|

.. _nav_core_base_local_planner_api:


4.1 APIの安定性
************************************************************
| 　C++ API が安定しています。
|

.. _nav_core_base_local_planner_cpp_api:


4.2 BaseLocalPlanner C++ API
************************************************************
| 　nav_core :: BaseLocalPlannerのC ++ APIに関するドキュメントは、 `BaseLocalPlannerドキュメント <http://www.ros.org/doc/api/nav_core/html/classnav__core_1_1BaseLocalPlanner.html>`_ にあります。
|

.. _nav_core_recovery:

============================================================
5. RecoveryBehavior
============================================================
| 　nav_core::RecoveryBehaviorは、ナビゲーションで使用されるリカバリ動作のインタフェースを提供します。 :doc:`move_base</move_base>` ノードのプラグインとして記述されたすべてのリカバリ動作は、このインタフェースに準拠する必要があります。nav_core::RecoveryBehaviorインタフェースを使用した現在のリカバリ動作は次のとおりです。
|

* :doc:`clear_costmap_recovery</clear_costmap_recovery>` - move_baseが使用するコストマップをユーザー指定の範囲外の静的マップに戻すリカバリ動作。
* :doc:`rotate_recovery</rotate_recovery>` - ロボットを360度回転させてスペースを空けることを試みるリカバリ動作。

|

.. _nav_core_recovery_api:


5.1 APIの安定性
************************************************************
| 　C++ API が安定しています。
|

.. _nav_core_recovery_cpp_api:


5.2 RecoveryBehavior C++ API
************************************************************
| 　nav_core :: RecoveryBehaviorのC ++ APIに関するドキュメントは、 `RecoveryBehaviorのドキュメント <http://www.ros.org/doc/api/nav_core/html/classnav__core_1_1RecoveryBehavior.html>`_ にあります。
|
