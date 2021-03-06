はじめに
=======================================

産業技術総合研究所ロボットイノベーション研究センターでは、NEDO「ロボット活用型市場化適用技術開発プロジェクト」において、未活用領域へのロボット導入に資するロボットソフトウェアのプラットフォーム化に係る種々の研究開発の一環として、オープンソースソフトウェアの設計仕様明確化、ドキュメント整備等を実施しています。 

本ドキュメントは、移動ロボットの地図作成およびナビゲーションのためのオープンソースソフトウェア（OSS）であるNavigation Stack（ROS(http://wiki.ros.org/)のパッケージ群の一つ）について、ソフトウェアの設計仕様(モジュール内部の詳細設計仕様を除く)をまとめたものです。

本ドキュメントの対象は、Navigation StackのROSノード群の二次利用者とします。二次利用とは、一般的なNavigationStackの利用に加えて、ROSノードの改良・改変や置き換え、様々な移動ロボットやセンサ（自社で開発した独自のロボットやセンサセット等）への適用等を想定しています。また、想定読者としては、移動ロボット制御の基礎のみ知っているハードウェア技術者や、あるいはハードウェア知識をあまり持たないソフトウェア技術者とします。

ノード、トピック、サービスなど、ROSの基本的な知識については、あらかじめ理解しておく必要があります。

