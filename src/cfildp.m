% net generation 

function [W, Z] = cfildp(n, Sxi, node_count, path_count, path_flow ,deviated_node_path,  alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent)
    W = [];      % 初始化 T 和 L两个集合为空集
    V = [];     %  T和L两个集合在这里表示为二维数组
    
    Z0 = 0;  % Z(L)
    Z1 = 0;  
    Z_ = 0;  % 修正的Z
    t = 1;

    while  t < (n + 1) %t < (m + 1)
        maxZ_ = -inf;  % 找到最大的Z_值
        it = 0;
        jit = 0;
        for It = 1:node_count % J(t)
            % 根据公式 选取的（i(t), Ji(t)）不应该出现在V集合中
            if ~isempty(V) && any(V(:, 1) == It) 
                continue;
            end
            for Jit = Sxi  % Sj(t) 这里两重循环取遍所有的（J(t), Sj(t)）
                tmpW = [W; [It, Jit]];
                Z1 = calculateZ(tmpW, path_count, path_flow, deviated_node_path, alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
                Z_ = (Z1- Z0)/ (C_cost + A_cost +  h_cost * Jit);
                if Z_ > maxZ_
                    % 如果Z_值大， 则作为备选方案
                    maxZ_ = Z_;
                    z0 = Z1;
                    it = It;
                    jit = Jit;
                    %[Z1 it Jjt]
                end 
            end
        end
        if it > 0  % 如果jt 不为0 则表明找到了合适的方案， 将方案（jt， sjt）添加到集合L T中
            W = [W; [it, jit]];
            V = [V; [it, jit]];
            Z0 = z0;
        end
        t = t + 1;
    end
    Z = Z0;
end



