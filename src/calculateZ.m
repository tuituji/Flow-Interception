% 这个函数是整个模型的主体部分

function Z = calculateZ(tmpL, path_count, path_flow, deviated_node_path, alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent)

    % L是已经安装了设施的的节点集合
    % 将当前计算的 （jt sjt） 添加到集合中构成 tmpL
    length_tmpL =  size(tmpL);
    length_tmpL = length_tmpL(1);
    % length_tmpL 记录的是tmpL集合中的元素数目  本来应该直接用length函数就可以了的
    % 但是第一次只用一个元素的时候 [[1 3]]会被简单的当成一个1*2的数组[1 3]，length
    % 求得的长度为2 后面都会出错
    length_opponent = length(E_opponent);
    mu_q_i = zeros(path_count, length_tmpL);
    mu_q_k = zeros(path_count, length_opponent);
    mu_q_sum = zeros( path_count, 1);
    
    y_q_i = zeros(path_count, length_tmpL);
    
    C_cost_tmp = zeros(1, length_tmpL);
    A_cost_tmp = zeros(1, length_tmpL);
    C_cost_tmp(:) = C_cost;
    A_cost_tmp(:) = A_cost;
    
    for q = 1:path_count
        mu_q_sum(q) = 0.0;  % mu_rho_sum 记录分母部分， 包括两个部分，
                         %  一个部分是竞争对手对流量的吸引
                         % 一部分是当前所有点（包括已安装和目前正在计算的点）对流量的吸引
        for k = 1:length(E_opponent) % 计算竞争对手对流量的吸引
            i = E_opponent(k, 1);  % 节点编号
            ji = E_opponent(k, 2); % 节点处的停车位数目
            mu_q_k(q, k) = exp(alpha + beta * ji/1000.0 - gama * deviated_node_path(q, i)/1000.0);
            mu_q_sum(q) = mu_q_sum(q) +  mu_q_k(q, k);
        end
        for k = 1:length_tmpL  % 这里显然只考虑有设备的节点  没有安排设备的节点mu_q_j值为0
            i = tmpL(k, 1);     % 节点编号
            ji = tmpL(k, 2);    % 节点处的停车位数目
            mu_q_i(q, k) = exp(alpha + beta * ji/1000.0  - gama * deviated_node_path(q, i)/1000.0);
            mu_q_sum(q) = mu_q_sum(q) + mu_q_i(q, k);
        end
        for i = 1:length_tmpL 
            if mu_q_sum == 0  % 这里会出现一种状况是 当前的点根本就没有出现在任何路径上 这些点不会对流量产生任何引，
                                % 因此mu_rho_sum会是0，所有x_rho_j也是0，但是不能将0作为分母，
                                % 由于这一点不会对流量产生任何吸引，这里直接给0就可以了
                                % 是否应该在进入这个函数之间就将这些点扔掉？？
                                
                               % 现在应该不会出现这种情况了， 所有点都是连接到路径上的，任何点都会吸引到流量 
                y_q_i(q, i) = 0;
				fprintf(2, 'error may occur, mu_q_sum is 0\n');
%           % assert(mu_q_sum(q) ~= 0, 'error mu_q_sum is 0'); 
            else
                y_q_i(q, i) = mu_q_i(q, i)/mu_q_sum(q);
            end    
        end
    end
    % 注意这里的计算，在公式里面是一堆求和 但是由于在matlab里面这些变量表示成了矩阵（数组），因此是可以直接使用矩阵运算的，
    % 而不需要使用循环对每个分量求值然后求和
    % flow 是一个 1*path_count的矩阵，
    % x_rho_j是一个path_count*node_count的矩阵，将这两个矩阵相乘得到一个1*node_count的矩阵
    % 然后将得到的矩阵所有分量相加（使用sum函数），得到的值和公式中的求和就是一样的了
    % 后面这部分也是一样的，tmpL(:,2)是有设备的节点的设备数目，是一个列矩阵，
    % 而f_fixed_cost_tmp是行矩阵，引出需要先做一个转置操作
    Z = L_year * r_index * theta * sum(path_flow * y_q_i) / 1e4 - sum(C_cost_tmp + A_cost_tmp + h_cost * tmpL(:, 2)');
end

