% �������������ģ�͵����岿��

function Z = calculateZ(tmpL, path_count, path_flow, deviated_node_path, alpha, beta, gama, theta, L_year, r_index, C_cost, A_cost, h_cost, E_opponent)

    % L���Ѿ���װ����ʩ�ĵĽڵ㼯��
    % ����ǰ����� ��jt sjt�� ��ӵ������й��� tmpL
    length_tmpL =  size(tmpL);
    length_tmpL = length_tmpL(1);
    % length_tmpL ��¼����tmpL�����е�Ԫ����Ŀ  ����Ӧ��ֱ����length�����Ϳ����˵�
    % ���ǵ�һ��ֻ��һ��Ԫ�ص�ʱ�� [[1 3]]�ᱻ�򵥵ĵ���һ��1*2������[1 3]��length
    % ��õĳ���Ϊ2 ���涼�����
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
        mu_q_sum(q) = 0.0;  % mu_rho_sum ��¼��ĸ���֣� �����������֣�
                         %  һ�������Ǿ������ֶ�����������
                         % һ�����ǵ�ǰ���е㣨�����Ѱ�װ��Ŀǰ���ڼ���ĵ㣩������������
        for k = 1:length(E_opponent) % ���㾺�����ֶ�����������
            i = E_opponent(k, 1);  % �ڵ���
            ji = E_opponent(k, 2); % �ڵ㴦��ͣ��λ��Ŀ
            mu_q_k(q, k) = exp(alpha + beta * ji/1000.0 - gama * deviated_node_path(q, i)/1000.0);
            mu_q_sum(q) = mu_q_sum(q) +  mu_q_k(q, k);
        end
        for k = 1:length_tmpL  % ������Ȼֻ�������豸�Ľڵ�  û�а����豸�Ľڵ�mu_q_jֵΪ0
            i = tmpL(k, 1);     % �ڵ���
            ji = tmpL(k, 2);    % �ڵ㴦��ͣ��λ��Ŀ
            mu_q_i(q, k) = exp(alpha + beta * ji/1000.0  - gama * deviated_node_path(q, i)/1000.0);
            mu_q_sum(q) = mu_q_sum(q) + mu_q_i(q, k);
        end
        for i = 1:length_tmpL 
            if mu_q_sum == 0  % ��������һ��״���� ��ǰ�ĵ������û�г������κ�·���� ��Щ�㲻������������κ�����
                                % ���mu_rho_sum����0������x_rho_jҲ��0�����ǲ��ܽ�0��Ϊ��ĸ��
                                % ������һ�㲻������������κ�����������ֱ�Ӹ�0�Ϳ�����
                                % �Ƿ�Ӧ���ڽ����������֮��ͽ���Щ���ӵ�����
                                
                               % ����Ӧ�ò��������������ˣ� ���е㶼�����ӵ�·���ϵģ��κε㶼������������ 
                y_q_i(q, i) = 0;
				fprintf(2, 'error may occur, mu_q_sum is 0\n');
%           % assert(mu_q_sum(q) ~= 0, 'error mu_q_sum is 0'); 
            else
                y_q_i(q, i) = mu_q_i(q, i)/mu_q_sum(q);
            end    
        end
    end
    % ע������ļ��㣬�ڹ�ʽ������һ����� ����������matlab������Щ������ʾ���˾������飩������ǿ���ֱ��ʹ�þ�������ģ�
    % ������Ҫʹ��ѭ����ÿ��������ֵȻ�����
    % flow ��һ�� 1*path_count�ľ���
    % x_rho_j��һ��path_count*node_count�ľ��󣬽�������������˵õ�һ��1*node_count�ľ���
    % Ȼ�󽫵õ��ľ������з�����ӣ�ʹ��sum���������õ���ֵ�͹�ʽ�е���;���һ������
    % �����ⲿ��Ҳ��һ���ģ�tmpL(:,2)�����豸�Ľڵ���豸��Ŀ����һ���о���
    % ��f_fixed_cost_tmp���о���������Ҫ����һ��ת�ò���
    Z = L_year * r_index * theta * sum(path_flow * y_q_i) / 1e4 - sum(C_cost_tmp + A_cost_tmp + h_cost * tmpL(:, 2)');
end

