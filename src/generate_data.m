
function [selected_path, x, y, path_route, path_flow, d_node_node, d_weight, deviated_node_path] = generate_data(node_count, path_count, basic_flow)

    % init path
    all_path = []; 
    for i = 1 : node_count
        for j = (i + 1) : node_count
            all_path  =[all_path; [i, j]]; 
        end
    end
    

%    point_x = zeros(1, node_count);
%    point_y = zeros(1, node_count);
    
    
    w=floor(sqrt(node_count));       
    h=floor(node_count/w);   
    x=[];
    y=[];
    for i=1:h           %使产生的随机点有其范围，使显示分布的更广
        for j=1:w
            x=[x 10*rand(1)+(j-1)*10];
            y=[y 10*rand(1)+(i-1)*10];
        end
    end
    ed=node_count-h*w;
    for i=1:ed
        x = [x 10*rand(1)+(i-1) * 10]; 
        y = [y 10*rand(1)+h * 10];
    end
    x = x/(w * 10);
    y = y/(h * 10 + 10);
%    plot(x, y, 'r*')
    
    path_route = cell(1, path_count);
    
    selected_path = zeros(path_count, 2);
    select_id = 1: length(all_path);
    for i = 1:path_count
        id = ceil(rand(1) * length(select_id));
        selected_path(i, :) = all_path(select_id(id), :);
        select_id(id) = [];
       % if repeate_path(selected_path, i -1, selected_path(i, :))
        %    disp('error repeate path');
        %end
    end
    
    %disp('init flow ')
    % 初始化流量
    path_flow = zeros(1, path_count);
    for i = 1:path_count
        % 基本流量1168000 基础上偏移 50万的范围
        path_flow(i) = basic_flow +  ceil(500000 * (1 - 2* rand(1)));  
    end

    % disp('init  distance ' )
    d_weight = ones(node_count)*(+inf);
    % 初始化权值矩阵  这里是随机初始化的并假设所有点之间都有一条直接相连的线路  不考虑 图的拓扑结构
    % 后面使用弗洛伊德算法计算后保证 求得点和点之间的最小距离
   % disp('init weight matrix');
    for i = 1: node_count
        d_weight(i, i) = 0;
    end
    
    nodes0 = 1:node_count;
    nodes1 = [];
    for i = 1: node_count
        id0 = ceil(rand(1) * length(nodes0)); % what if rand(1) is 0
        id0 = max(id0, 1);
        if ~isempty(nodes1)
            id1 = ceil(rand(1) * length(nodes1));
            id1 = max(id1, 1);  
            %d_weight(nodes0(id0), nodes1(id1)) = 500 + ceil(rand(1) * 1500); % 距离最小500m  最大2km
            %d_weight(nodes1(id1), nodes0(id0)) = d_weight(nodes0(id0), nodes1(id1));
            d_weight(nodes0(id0), nodes1(id1)) = 500 + ceil(1500 * sqrt((x(nodes0(id0))-x(nodes1(id1)))^2 + (y(nodes0(id0))-y(nodes1(id1)))^ 2));  
            d_weight(nodes1(id1), nodes0(id0)) = d_weight(nodes0(id0), nodes1(id1)) ;
        end
        nodes1 = [nodes1, nodes0(id0)];
        nodes0(id0) = [];
    end
    
      % 额外添加一些点
%     for i = 1:ceil(node_count/2)
%         i0 = ceil(rand(1) * node_count);
%         i1 = ceil(rand(1) * node_count);
%         if d_weight(i0, i1) == inf
%             d_weight(i0, i1) = 500 + ceil(rand(1) * 1500); % 距离最小500m  最大2km
%             d_weight(i1, i0) = d_weight(i0, i1);
%         end
%     end
        
   % disp('calculate shortest length matrix');
    % calculate the shortest distance matrix 
    % 根据权值矩阵计算点和点之间的最小距离矩阵
    d_node_node = shortdf(d_weight);
    
    
%     for i = 1: node_count
%         for j = (i+1) : node_count
%             if d_weight(i, j) > d_node_node(i, j)
%                 d_weight(i, j) = +inf;
%                 d_weight(j, i) = +inf;
%             ends
%         end
%     end
    disp ('calculate route');
    for i = 1:path_count
        path_route{i} = n2shortf(d_weight, d_node_node, selected_path(i, 1), selected_path(i, 2));
    end
    
    % 计算偏移距离
    % 偏移距离的计算 （我中觉得理解错了？？） 没问题了
    deviated_node_path = zeros(path_count, node_count);
    for i = 1:path_count
        for j = 1:node_count
            % according to the definition of deviated distance 
            deviated_node_path(i, j) = d_node_node(selected_path(i, 1), j)  + d_node_node(selected_path(i, 2), j) - d_node_node(selected_path(i, 1),selected_path(i, 2)); 
        end
    end
end

% % make sure not any two path are the same
function path_repeated = repeate_path(selected_path, path_prev_count, path_i)
     path_repeated = 0;
     for j = 1:path_prev_count
         % if isequal(path{j}, path_i)  % 如果两条路径所有节点完全相同
         % 目前使用的判定标准是如果 首尾节点相同就认为是相同的路径
         % 这样考虑主要是在模型中，偏移距离的计算的就是首尾两个点
         if selected_path(j, 1) == path_i(1) && selected_path(j, 2) == path_i(2)
             path_repeated = 1;
         end
%         if path{j}(1) == path_i(2) && path{j}(2) == path_i(1)
%             path_repeated = 1;
%         end
    end
end




