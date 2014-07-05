
function P = n2shortf(W, U, k1, k2)
    n = length(W);
    P1= zeros(1, n);
    k = 1;
    P1(k) = k2;
    V = ones(1, n) *inf;
    kk = k2;
    while kk ~= k1
        for i = 1:n
            V(1, i) = U(k1, kk) - W(i, kk);
            if V(1, i) == U(k1, i)
                P1(k + 1) = i;
                kk = i;
                k = k + 1;
            end
        end
    end
    k = 1;
    wrow = find(P1 ~= 0);
    for j = length(wrow):(-1):1
        P(k) = P1(wrow(j));
        k = k + 1;
    end
    P;
end