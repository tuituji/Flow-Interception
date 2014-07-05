function [L, Z] = enumerate(n, Sxi, node_count, path_count, path_flow, deviated_node_path, alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent)

 %   assert(n == 3, 'error number of m');

    Z = -inf;
    
    length_Sxi = length(Sxi);
%    all_L = zeros(node_count *  (node_count-1) *  (node_count-2) * length_M * length_M * length_M, 2);

    one_L = zeros(node_count * length_Sxi, 2);
    for i = 1: node_count
        for j  = 1: length_Sxi
            one_L ((i-1)* length_Sxi + j, :) = [i, Sxi(j)];
        end
    end

    length_one_L = length(one_L);
    for i = 1 : length_one_L
        for j = (ceil(i/length_Sxi) * length_Sxi + 1): length_one_L;
            for k = (ceil(j/length_Sxi) * length_Sxi + 1): length_one_L;
                tmpL = [one_L(i, :); one_L(j, :); one_L(k, :)];
               
                tmpZ = calculateZ(tmpL, path_count, path_flow, deviated_node_path, alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
                %fprintf(1, 'i=[%d %d] j = [%d  %d], k = [%d  %d] Z=%f\n',tmpL(1, 1) , tmpL(1, 2), tmpL(2, 1), tmpL(2, 2), tmpL(3, 1), tmpL(3, 2), tmpZ);
                if tmpZ > Z
                    Z = tmpZ;
                    L = tmpL;
                end
            end
        end
    end
end
