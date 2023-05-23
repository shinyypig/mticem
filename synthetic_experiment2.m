%% read data
addpath(genpath(pwd));
clear;
fileName = 'Salinas';
him = importdata(['data/' fileName '.mat']);
gt = importdata(['data/' fileName '_gt.mat']);

%% create synthetic data
him = him_norm(him);
[m, n, l] = size(him);

sim = him(:, :, [50, 100, 200]);
for i = 1:3
    sim(:, :, i) = mat2gray(sim(:, :, i));
end

%% select 1 2 7 objects to be the targets
cs = [1 2 7];

D = select_targets(reshape(him, [], l), gt(:), cs);
X = reshape(him, [], l);

d = 0;
for i = 1:length(cs)
    d = d + double(gt(:) == cs(i));
end

%% plot auc curves with different number of bands selected
band_num = 3:1:20;
auc = zeros([2, length(band_num)]);
for i = 1:length(band_num)
    [sel_list, ~] = FVGBS(him, [], band_num(i));
    X_ = X(:, sel_list);
    D_ = D(:, sel_list);

    y1 = mtcem(X_, D_);
    y2 = mticem(X_, D_);

    [~, ~, ~, auc(2, i)] = perfcurve(d, y1, 1);
    [~, ~, ~, auc(1, i)] = perfcurve(d, y2, 1);
end

figure, hold on;
plot(band_num, auc(2, :), '-^', 'LineWidth', 2, 'MarkerSize', 8);
plot(band_num, auc(1, :), '-o', 'LineWidth', 2, 'MarkerSize', 8);
hold off;
set(gca, 'FontSize', 20);
legend({'MTCEM' 'MTICEM'}, 'Location', "best");
grid on;
xlabel('Number of Bands');
ylabel('AUC');

%%
function D = select_targets(X, gt, cs)
    d = size(X, 2);
    num = length(cs);
    D = zeros([num, d]);
    for i = 1:num
        D(i, :) = mean(X(gt == cs(i), :), 1);
    end
end
