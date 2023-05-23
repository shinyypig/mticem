%% load data
addpath(genpath(pwd));
clear, close all;
fileName = 'Salinas';
him = importdata(['data/' fileName '.mat']);
gt = importdata(['data/' fileName '_gt.mat']);

%% generate the used data
him = him_norm(him);
[m, n, l] = size(him);

cs = 6;
d = gt(:) == cs;

[sel_list, ~] = FVGBS(him, [], 30);
X = reshape(him, [], l);
X = X(:, sel_list);

%% plot auc curve with different number of targets selected
target_num = 1:2:25;
auc = zeros([2, length(target_num)]);
for i = 1:length(target_num)
    for t = 1:50
        D = random_select(X, d, target_num(i));

        y1 = mtcem(X, D);
        y2 = mticem(X, D);

        [~, ~, ~, tmp1] = perfcurve(d, y1, 1);
        [~, ~, ~, tmp2] = perfcurve(d, y2, 1);
        auc(2, i) = auc(2, i) + tmp1;
        auc(1, i) = auc(1, i) + tmp2;
    end
end
auc = auc / t;

figure, hold on;
plot(target_num, auc(2, :), '-o', 'LineWidth', 2, 'MarkerSize', 8);
plot(target_num, auc(1, :), '-^', 'LineWidth', 2, 'MarkerSize', 8);
hold off;
set(gca, 'FontSize', 20);
legend({'MTCEM' 'MTICEM'}, 'Location', "best");
grid on;
xlabel('Number of Target spectra');
ylabel('AUC');

%%
function D = random_select(X, mask, num)
    X = X(mask, :);
    idx = randperm(size(X, 1), num);
    D = X(idx, :);
end
