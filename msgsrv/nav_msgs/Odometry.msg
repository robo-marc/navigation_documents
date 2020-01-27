#////////////////////////////////////////////////////////////////////////////////
#/// @struct     nav_msgs/Odometry
#/// @brief      オドメトリ情報
#///
#/// オドメトリ情報は、標準的なNavigationスタックの構成では、odom座標軸における
#/// ロボット(base_link座標軸)の推定自己位置および現在速度（並進速度および回転
#/// 速度）を通知します。
#///
#////////////////////////////////////////////////////////////////////////////////

Header header                                #//!< ヘッダ
string child_frame_id                        #//!< 子フレームID
geometry_msgs/PoseWithCovariance pose        #//!< 推定自己位置
geometry_msgs/TwistWithCovariance twist      #//!< 現在速度
