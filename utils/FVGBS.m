function [sel_list, t] = FVGBS(him, noisyBands, band_num)
    if length(size(him)) == 2
        [num, l] = size(him);
        him(:, noisyBands) = [];
        X = reshape(him, [], l - length(noisyBands));
    elseif length(size(him)) == 3
        [m, n, l] = size(him);
        num = m * n;
        him(:, :, noisyBands) = [];
        X = reshape(him, [], l - length(noisyBands));
    end
    
    R = X' * X / num;

    sel_list = (1: l)';
    sel_list(noisyBands) = [];
    
    tic;
    K = pinv(R);
    for i = band_num + 1: l - length(noisyBands)
        [~, idx] = max(diag(K));

        c = K(idx, idx);
        K(:, idx) = [];
        b = -K(idx, :);
        K(idx, :) = [];

        K = K - b' * b / c;

        sel_list(idx) = [];
    end
    t = toc;
end
