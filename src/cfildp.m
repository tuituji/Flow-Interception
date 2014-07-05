% net generation 

function [W, Z] = cfildp(n, Sxi, node_count, path_count, path_flow ,deviated_node_path,  alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent)
    W = [];      % ��ʼ�� T �� L��������Ϊ�ռ�
    V = [];     %  T��L���������������ʾΪ��ά����
    
    Z0 = 0;  % Z(L)
    Z1 = 0;  
    Z_ = 0;  % ������Z
    t = 1;

    while  t < (n + 1) %t < (m + 1)
        maxZ_ = -inf;  % �ҵ�����Z_ֵ
        it = 0;
        jit = 0;
        for It = 1:node_count % J(t)
            % ���ݹ�ʽ ѡȡ�ģ�i(t), Ji(t)����Ӧ�ó�����V������
            if ~isempty(V) && any(V(:, 1) == It) 
                continue;
            end
            for Jit = Sxi  % Sj(t) ��������ѭ��ȡ�����еģ�J(t), Sj(t)��
                tmpW = [W; [It, Jit]];
                Z1 = calculateZ(tmpW, path_count, path_flow, deviated_node_path, alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent);
                Z_ = (Z1- Z0)/ (C_cost + A_cost +  h_cost * Jit);
                if Z_ > maxZ_
                    % ���Z_ֵ�� ����Ϊ��ѡ����
                    maxZ_ = Z_;
                    z0 = Z1;
                    it = It;
                    jit = Jit;
                    %[Z1 it Jjt]
                end 
            end
        end
        if it > 0  % ���jt ��Ϊ0 ������ҵ��˺��ʵķ����� ��������jt�� sjt����ӵ�����L T��
            W = [W; [it, jit]];
            V = [V; [it, jit]];
            Z0 = z0;
        end
        t = t + 1;
    end
    Z = Z0;
end



