
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
    for i=1:h           %ʹ��������������䷶Χ��ʹ��ʾ�ֲ��ĸ���
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
    % ��ʼ������
    path_flow = zeros(1, path_count);
    for i = 1:path_count
        % ��������1168000 ������ƫ�� 50��ķ�Χ
        path_flow(i) = basic_flow +  ceil(500000 * (1 - 2* rand(1)));  
    end

    % disp('init  distance ' )
    d_weight = ones(node_count)*(+inf);
    % ��ʼ��Ȩֵ����  �����������ʼ���Ĳ��������е�֮�䶼��һ��ֱ����������·  ������ ͼ�����˽ṹ
    % ����ʹ�ø��������㷨�����֤ ��õ�͵�֮�����С����
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
            %d_weight(nodes0(id0), nodes1(id1)) = 500 + ceil(rand(1) * 1500); % ������С500m  ���2km
            %d_weight(nodes1(id1), nodes0(id0)) = d_weight(nodes0(id0), nodes1(id1));
            d_weight(nodes0(id0), nodes1(id1)) = 500 + ceil(1500 * sqrt((x(nodes0(id0))-x(nodes1(id1)))^2 + (y(nodes0(id0))-y(nodes1(id1)))^ 2));  
            d_weight(nodes1(id1), nodes0(id0)) = d_weight(nodes0(id0), nodes1(id1)) ;
        end
        nodes1 = [nodes1, nodes0(id0)];
        nodes0(id0) = [];
    end
    
      % �������һЩ��
%     for i = 1:ceil(node_count/2)
%         i0 = ceil(rand(1) * node_count);
%         i1 = ceil(rand(1) * node_count);
%         if d_weight(i0, i1) == inf
%             d_weight(i0, i1) = 500 + ceil(rand(1) * 1500); % ������С500m  ���2km
%             d_weight(i1, i0) = d_weight(i0, i1);
%         end
%     end
        
   % disp('calculate shortest length matrix');
    % calculate the shortest distance matrix 
    % ����Ȩֵ��������͵�֮�����С�������
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
    
    % ����ƫ�ƾ���
    % ƫ�ƾ���ļ��� �����о��������ˣ����� û������
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
         % if isequal(path{j}, path_i)  % �������·�����нڵ���ȫ��ͬ
         % Ŀǰʹ�õ��ж���׼����� ��β�ڵ���ͬ����Ϊ����ͬ��·��
         % ����������Ҫ����ģ���У�ƫ�ƾ���ļ���ľ�����β������
         if selected_path(j, 1) == path_i(1) && selected_path(j, 2) == path_i(2)
             path_repeated = 1;
         end
%         if path{j}(1) == path_i(2) && path{j}(2) == path_i(1)
%             path_repeated = 1;
%         end
    end
end




