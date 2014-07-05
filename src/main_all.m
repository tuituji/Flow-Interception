node_count = 40;  % 节点总数
path_count = 4;   % 路径总数

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
h_cost = 22.0;  % 每个停车位的成本 25万

do_plot = 1;  % 

%%%%%%%%%%% 
% 论文中调整的参数
N0 = [20, 30, 40]; % 节点数目
n0 = [ 3 ];             % 设施数目
alpha0 = [0.3 , 0.7]; % 
beta0 = [0.2, 0.8];
gama0 = [0.25, 0.75];
times = 2;
%%%%%%%%%%%


rand('state',0);  %  设置随机数生成器的种子 相同的种子将会得到相同的随机数和结果

fd = fopen('result.txt', 'w');
fprintf(1,  'N\t\tn\t\talpha\t\tbeta\t\tgama\t\tmean_error\t\tmax_error\t\tmean_time1\t\tmean_time0\n');
fprintf(fd, 'N\t\tn\t\talpha\t\tbeta\t\tgama\t\tmean_error\t\tmax_error\t\tmean_time1\t\tmean_time0\n');
for i = N0
    for j = n0
        for k = alpha0
            for l = beta0
                for m = gama0
                    node_count = i;
                    n = j;
                    alpha = k;
                    beta = l;
                    gama = m;
                   
                    result1 = zeros(1, times);
                    result0 = zeros(1, times);
                    time1 = zeros(1, times);
                    time0 = zeros(1, times);
                    fprintf(1, '%d\t\t%d\t\t%f\t\t%f\t\t%f\t\t', node_count, n, alpha, beta, gama);
                    for x = 1:times
                        %[selected_path, path_flow, d_node_node, d_weight, deviated_node_path] =  generate_data(node_count, path_count, basic_flow);
                        [selected_path, points_x, points_y, path_route, path_flow, d_node_node, d_weight, deviated_node_path] = generate_data(node_count, path_count, basic_flow);
                        E_opponent = [1 2000; 2 3000 ]; % 竞争对手的设施 这个你看情况自己定义了
                        
						t1 = clock;						
                        [ enum_L, enum_Z ] = enumerate(n, Sxi, node_count, path_count, path_flow ,deviated_node_path,  alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
						t2 = clock;
						time0(x) = etime(t2,t1);
                        
						t1 = clock;	
                        [cfildp_L, cfildp_Z] = cfildp(n, Sxi, node_count, path_count, path_flow ,deviated_node_path,  alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
                        t2=clock;
						time1(x) = etime(t2,t1);
                        
                        result1(x) = cfildp_Z;
                        result0(x) = enum_Z;
                        
						if time0(x) < 0 || time1(x) < 0
                            str = sprintf('%d_%d_%0.1f_%0.1f_%0.1f_%d.mat', node_count, n, alpha, beta, gama, x);
							save(str);
                        end
                        if do_plot
                            close all;
                            plot_graph( d_weight, path_route, path_flow, basic_flow ,points_x, points_y, cfildp_L, enum_L, E_opponent);
                            set(gcf,'PaperPositionMode','auto');
                            mkdir('fig');
                            str = sprintf('fig\\%d_%d_%0.1f_%0.1f_%0.1f_%d.png', node_count, n, alpha, beta, gama, x);
                            print(gcf,'-dpng','-r0',str);
                        end
                    end
                    if any( result1 - result0 > 1e-6)  % 贪婪算法求得的解应该比 枚举法小 或者相同  
					     % 由于浮点数舍入误差的问题  不能写 0  而写成 1e-6
                        fprintf(2, 'maybe error enumerate ');
                        fprintf(2, '%d\t\t%d\t\t%f\t\t%f\t\t%f\t\t%f\t\t%f\n', node_count, n, alpha, beta, gama, result1(x), result0(x));
						fprintf(fd, 'maybe error enumerate ');
                        fprintf(fd, '%d\t\t%d\t\t%f\t\t%f\t\t%f\t\t', node_count, n, alpha, beta, gama);
						for y = 1:times
							fprintf(fd, '%f\t\t%f\n',  result0(y), result1(y));
						end
						fprintf('\n\n');
                        str = sprintf('%d_%d_%0.1f_%0.1f_%0.1f_%d.mat', node_count, n, alpha, beta, gama, x);
                        save(str);
                    end

                    fprintf(1,  '%f\t\t%f\t\t%f\t\t%f\n', mean((result0 - result1)./result0), max((result0 - result1)./result0), mean(time1), mean(time0));
                    fprintf(fd, '%d\t\t%d\t\t%f\t\t%f\t\t%f\t\t', node_count, n, alpha, beta, gama);
                    fprintf(fd, '%f\t\t%f\t\t%f\t\t%f\n', mean((result0 - result1)./result0), max((result0 - result1)./result0), mean(time1), mean(time0));
                end
            end
        end
    end
end

fclose(fd);

