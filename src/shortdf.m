% get the shortest distance matrix D given weight matrix W
% �ο��� ͼ���㷨����MATLABʵ�� һ���ʵ�ִ���
function D = shortdf(W)
    n = length(W);
    D = W;
    m = 1;
    % the Froyd algorithms
    while m <= n
        for i = 1:n
            for j = 1:n
                if D(i, j) > D(i, m) + D(m, j)
                    D(i, j) = D(i, m) + D(m, j);
                end
            end
        end
        m = m + 1;
    end
    D;
end
