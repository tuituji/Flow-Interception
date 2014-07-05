clc;
node_count = 6;  % �ڵ�����
path_count = 3;   % ·������

L_year = 15;
r_index = 2000;
basic_flow = ceil(5840000/path_count); 

alpha = 0.3;  % ��������������̶�Ȩ������
beta = 0.2;   % ͣ��λ����Ȩ������
theta = 0.1;  % ����ϵ������Լ10%������������
gama = 0.5;   % ƫ�����Ȩ������
n = 3;       % �ܹ���n����ʩ
step = 500;
Sxi = 2000: step : 3000;
C_total_cost = 270000.0; % 27��
A_total_cost = 20000.0;  % 2��

C_cost = C_total_cost/n;  % ƽ̯��ÿ����ʩ�ϵķ���
A_cost = A_total_cost/n;  % 
%h_cost = 0.25;  % ÿ��ͣ��λ�ĳɱ� 0.25�� 2500
h_cost = 22;
% step 1 
% path ��
%    �����е�·����cell���� ��cell�����ÿһ��Ԫ����һά����  ����������·�� 1-2-3  6-7��
%    ��path�еĴ洢��ʽΪ
% path = {[1 2 3] [6 7]} ʹ��path{1} ���Է��ʵ�����[1 2 3]
% flow:
%    ���� һά �������ͣ� ������ɣ� ��С�����Լ�ȥ generate_data�޸�
% d_node_node��
%    ��͵�֮��ľ������  ����ͼ���������� 1 2 3  1-2֮�����Ϊ5.5�� 3�� 1 2 ��������
%    ��������Ϊ
%    0     5.5    Inf
%    5.5    0     Inf
%    Inf   Inf    Inf
% deviated_node_path��
%    ƫ�ƾ������ path_count��node_count�еĶ�ά���飬��¼ÿһ���ڵ㵽ÿһ��·���ϵ�ƫ�ƾ���
%    �Ҹ��˸о�����ط�����ƺ�����Щ���⣬ ����Ҫ����һ�£�����
% ��ο� generate_data.m�ļ��鿴generate_data�����Ķ���

%rand('state',0);  %  ��������������������� ��ͬ�����ӽ���õ���ͬ��������ͽ��
%[selected_path, path_route, path_flow, d_node_node, d_weight, deviated_node_path] =  generate_data(node_count, path_count, basic_flow);
[selected_path, points_x, points_y, path_route, path_flow, d_node_node, d_weight, deviated_node_path] = generate_data(node_count, path_count, basic_flow);
%E_opponent = [selected_path(1,1) 2000; selected_path(2, 1) 3000 ]; % �������ֵ���ʩ ����㿴����Լ�������



E_opponent = [1 2000; 2 3000 ]; % �������ֵ���ʩ ����㿴����Լ�������

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
