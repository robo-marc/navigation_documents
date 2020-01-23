inflation
=======================================
目次
    
| 　1. :ref:`インフレーションコストマッププラグイン<inflation_inflation_costmap_plugin>`
| 　　1.1. :ref:`インフレーション<inflation_inflation>`
| 　　1.2. :ref:`ROS API<inflation_ros_api>`
| 　　　1.2.1. :ref:`パラメータ<inflation_parameters>`
|

.. _inflation_inflation_costmap_plugin:

============================================================
1. インフレーションコストマッププラグイン
============================================================


.. _inflation_inflation:


1.1. インフレーション
************************************************************
costmap_2dの :ref:`インフレーション <costmap2d_inflation>` を参照のこと。

|



.. _inflation_ros_api:


1.2. ROS API
************************************************************


.. _inflation_parameters:


1.2.1. パラメータ
------------------------------------------------------------
.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "~<name>/inflation_radius", "マップの障害物コスト値をインフレーションする半径", "double", "m", "0.55"
   "~<name>/cost_scaling_factor", "| インフレーション時にコスト値に適用するスケーリング係数。 コスト関数は、内接半径距離よりも遠く、実際の障害物から離れるインフレーション半径距離よりも近いコストマップ内のすべてのセルに対して次のように計算されます。 
    
        | exp( -1.0 * cost_scaling_factor * ( 障害物からの距離 - 内接半径 ) ) * ( 致命的コスト値 - 1 )
   
   | ここで、致命的コスト値(costmap_2d :: INSCRIBED_INFLATED_OBSTACLE)は現在254です。注：式でcost_scaling_factorに負の値が乗算されるため、係数を大きくすると結果のコスト値が減少します。", "double", "\-", "10.0"

|

