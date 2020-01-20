staticmap
=======================================
目次
    
| 　1. :ref:`概要<staticmap_overview>`
| 　　1.1. :ref:`サブスクライブトピック<staticmap_subscribed_topics>`
| 　　1.2. :ref:`パラメータ<staticmap_parameters>`
|

.. _staticmap_overview:

============================================================
1. 概要
============================================================
静的マップには、外部ソースからのほとんど変更されないデータが組み込まれています（マップの構築に関するドキュメントについては、 :doc:`map_server <map_server>` パッケージを参照してください）。

.. _staticmap_subscribed_topics:


1.1. サブスクライブトピック
************************************************************
.. csv-table:: 
   :header: "トピック名", "型", "内容"
   :widths: 10, 10, 30

   "map", "`nav_msgs/OccupancyGrid <http://docs.ros.org/api/nav_msgs/html/msg/OccupancyGrid.html>`__", "コストマップには、ユーザー生成の静的マップから初期化するオプションがあります（ :ref:`static_map <staticmap_parameters>` パラメーターを参照）。 このオプションが選択されている場合、コストマップはこのマップを取得するために :doc:`map_server <map_server>` のサービスを使用します。"


.. _staticmap_parameters:


1.2. パラメータ
************************************************************
.. csv-table:: 
   :header: "パラメータ名", "内容", "型", "単位", "デフォルト"
   :widths: 10, 50, 5, 5, 8

   "unknown_cost_value", "マップサーバーからマップを読み込むときに、コストを未知スペースと見なす値。コストマップが未知スペースを追跡していない場合、この値のコストは占有と見なされます。値がゼロの場合も、このパラメーターは使用されません。", "int", "\-", "-1"
   "lethal_cost_threshold", "マップサーバーからマップを読み込むときに致命的コストとみなすしきい値。", "int", "\-", "100"
   "map_topic", "コストマップが静的マップをサブスクライブするトピック名。このパラメーターは、異なる静的マップを使用する単一のノード内に複数のコストマップインスタンスがある場合に役立ちます。 - *ナビゲーション1.3.1の新機能*", "string", "\-", "map"
   "first_map_only", "trueの場合、マップトピックの最初のメッセージのみをサブスクライブし、後続のすべてのメッセージを無視します", "bool", "\-", "false"
   "subscribe_to_updates", "trueの場合、map_topicに加えて、map_topic + ""_updates""もサブスクライブします", "bool", "\-", "false"
   "track_unknown_space", "trueの場合、マップメッセージ内の未知スペース値はレイヤーに直接変換されます。それ以外の場合、マップメッセージの未知スペース値は、レイヤーでFREE_SPACEとして変換されます。", "bool", "\-", "true"
   "use_maximum", "静的レイヤーが最下層でない場合にのみ重要です。 trueの場合、最大値のみがマスターコストマップに書き込まれます。", "bool", "\-", "false"
   "trinary_costmap", "trueの場合、すべてのマップメッセージ値をNO_INFORMATION / FREE_SPACE / LETHAL_OBSTACLE（3つの値）に変換します。 falseの場合、中間値を含む全範囲の値が使用可能です。", "bool", "\-", "true"

|

