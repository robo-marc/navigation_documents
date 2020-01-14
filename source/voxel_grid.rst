voxel_grid
================================================

目次
    
| 　1. :ref:`概要<voxelgrid_overview>`
| 　2. :ref:`APIの安定性<voxelgrid_api_stability>`
|

.. _voxelgrid_overview:

============================================================
1. 概要
============================================================
voxel_gridは、効率的な3Dボクセルグリッドの実装を提供します。 占有グリッドは、セルの状態をマーク、空き、未知の3つの異なる表現でサポートできます。 基本実装がビット単位のAND及びOR整数演算によるため、ボクセルグリッドはボクセル列ごとに16の異なるレベルのみをサポートします。 ただし、この制限により、標準の2D構造に匹敵するグリッドでレイトレーシングとセルマーキングのパフォーマンスが得られ、ほとんどの3D構造と比較して非常に高速です。

|

* 管理状態: 管理済み
* 管理者: David V. Lu!! <davidvlu AT gmail DOT com>, Michael Ferguson <mfergs7 AT gmail DOT com>, Aaron Hoy <ahoy AT fetchrobotics DOT com>
* 著者: Eitan Marder-Eppstein, Eric Berger, contradict@gmail.com
* ライセンス: BSD
* ソース: git `https://github.com/ros-planning/navigation.git <https://github.com/ros-planning/navigation.git>`__  (branch: melodic-devel)

.. _voxelgrid_api_stability:

============================================================
2. APIの安定性
============================================================
voxel_gridには、公式にサポートしているAPIはありません。 コードを自由に使用してください。現在のAPIの安定性については何も保証していません。
