clc;
node_count = 6;  % 节点总数
path_count = 3;   % 路径总数

L_year = 15;
r_index = 2000;
basic_flow = ceil(5840000/path_count); 

alpha = 0.3;  % 建筑设计吸引力程度权重因子
beta = 0.2;   % 停车位数量权重因子
theta = 0.1;  % 消费系数，大约10%的流量会消费
gama = 0.5;   % 偏离距离权重因子
n = 3;       % 总共设n个设施
step = 500;
Sxi = 2000: step : 3000;
C_total_cost = 270000.0; % 27亿
A_total_cost = 20000.0;  % 2亿

C_cost = C_total_cost/n;  % 平摊到每个设施上的费用
A_cost = A_total_cost/n;  % 
%h_cost = 0.25;  % 每个停车位的成本 0.25万 2500
h_cost = 22;
% step 1 
% path ：
%    是所有的路径，cell类型 该cell里面的每一个元素是一维数组  比如有两条路径 1-2-3  6-7，
%    则path中的存储形式为
% path = {[1 2 3] [6 7]} 使用path{1} 可以访问到数组[1 2 3]
% flow:
%    流量 一维 数组类型， 随机生成， 大小可以自己去 generate_data修改
% d_node_node：
%    点和点之间的距离矩阵，  比如图中有三个点 1 2 3  1-2之间距离为5.5， 3和 1 2 不相连，
%    则距离矩阵为
%    0     5.5    Inf
%    5.5    0     Inf
%    Inf   Inf    Inf
% deviated_node_path：
%    偏移距离矩阵， path_count行node_count列的二维数组，记录每一个节点到每一条路径上的偏移距离
%    我个人感觉这个地方理解似乎还有些问题， 还需要讨论一下？？？
% 请参看 generate_data.m文件查看generate_data函数的定义

%rand('state',0);  %  设置随机数生成器的种子 相同的种子将会得到相同的随机数和结果
%[selected_path, path_route, path_flow, d_node_node, d_weight, deviated_node_path] =  generate_data(node_count, path_count, basic_flow);
[selected_path, points_x, points_y, path_route, path_flow, d_node_node, d_weight, deviated_node_path] = generate_data(node_count, path_count, basic_flow);
%E_opponent = [selected_path(1,1) 2000; selected_path(2, 1) 3000 ]; % 竞争对手的设施 这个你看情况自己定义了



E_opponent = [1 2000; 2 3000 ]; % 竞争对手的设施 这个你看情况自己定义了

tic;
[ enum_L, enum_Z ] = enumerate(n, Sxi, node_count, path_count, path_flow ,deviated_node_path,  alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
time = toc;
disp(['time for enumerate ' ,num2str(time)]);
enum_L
enum_Z
tic;
[cfildp_L, cfildp_Z] = cfildp(n, Sxi, node_count, path_count, path_flow ,deviated_node_path,  alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
time = toc;
disp(['time for cfildp ' ,num2str(time)]);
cfildp_L
cfildp_Z
(cfildp_Z- enum_Z)/enum_Z

plot_graph( d_weight, path_route, path_flow, basic_flow ,points_x, points_y, cfildp_L, enum_L, E_opponent);
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','-r0','main_test.png');
    
pause
close all
