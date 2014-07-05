% get the shortest distance matrix D given weight matrix W
% 参考了 图论算法及其MATLAB实现 一书的实现代码
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
