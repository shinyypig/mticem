function him_n = him_norm(him)
    [m, n, l] = size(him);
    him_n = zeros([m, n, l]);
    for i = 1:l
        tmp = him(:, :, i);
        tmp = tmp(:);
        t_max = max(tmp);
        t_min = min(tmp);
        him_n(:, :, i) = (him(:, :, i) - t_min) / (t_max - t_min);
    end
end
