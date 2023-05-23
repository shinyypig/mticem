function X_ = band_resample(X, num)
%     [n, l] = size(X);
%     d = floor(l / num);
%     X_ = zeros(n, num);
%     for i = 1: num
%         X_(:, i) = mean(X(:,  d*(i-1)+1: d*i), 2);
%     end
    [sel_list, ~] = FVGBS(X, [], num);
    X_ = X(:, sel_list);
end