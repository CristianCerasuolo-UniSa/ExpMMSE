function [] = BayesianGMVaryingSW(min, max, step, N, muY, sY, nMC)

assert(min < max, 'min must be lesser than max')

num_tests = (max-min)/step + 1; % Number of iterations

MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);

i = 1;
for sW = min:step:max

    %%% EVALUATE FOR CURRENT sW
    [meanMMSE, meanAVE, mseMMSE, mseAVE, varAVE, varMMSE, Y] = ...
    BayesianGM(N, muY, sY, sW, nMC);

    %%% STORE MSE AND PREDICTION MADE BY EACH ESTIMATOR
    MSEs_MMSE(i) = mseMMSE;
    MSEs_AVE(i) = mseAVE;

    AVEs_MMSE(i) = meanMMSE;
    AVEs_AVE(i) = meanAVE;
    aveY(i) = mean(Y); % Y is the vector of sampled y for each MC

    VARs_AVE(i) = varAVE;
    VARs_MMSE(i) = varMMSE;

    i = i + 1;
end

%%% Compare performances of each estimator when sW varies
fig1 = "MSE varying sW";
figure('name', fig1)
hold on
grid
plot(min:step:max, MSEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
plot(min:step:max, MSEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'AVE')
xline(sY*N, 'black', {'$$\sigma_Y^2\cdot N$$'}, 'interpreter', 'latex');
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_Y$$ =', num2str(sY), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_W$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)
legend('MMSE', 'Arithmetic Mean', 'location', 'northeast')

saveas(gcf, fig1, 'png')

%%% Compare estimates of each estimator when sW varies
fig2 = "Estimates varying sW";
figure('name', fig2)
hold on
grid

plot(min:step:max, aveY, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of Y')
plot(min:step:max, AVEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of MMSE estimation')
plot(min:step:max, AVEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of Arithmetic Mean estimation')
plot(min:step:max, muY*ones(num_tests), '--', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Real mean of Y')
xline(sY*N, 'black', {'$$\sigma_Y^2\cdot N$$'}, 'interpreter', 'latex');
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_Y$$ =', num2str(sY), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_W$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('$$\hat Y$$', 'interpreter', 'latex','FontSize', 18)
legend('Mean of Y', 'MMSE', 'Arithmetic Mean', 'location', 'northeast')

saveas(gcf, fig2, 'png')

%%% Compares the theoretical error of each estimator versus the MSE
fig3 = "Error comparing varying sW";
figure('Name', fig3)

subplot(2, 1, 1)
plot(min:step:max, VARs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Variance')
hold on
grid
plot(min:step:max, MSEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
xline(sY*N, 'black', {'$$\sigma_Y^2\cdot N$$'}, 'interpreter', 'latex');
title("MMSE")
xlabel({'$$\sigma_W^2$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('Error', 'interpreter', 'latex','FontSize', 18)
legend('Variance', 'MSE', 'location', 'northeast')

subplot(2, 1, 2)
plot(min:step:max, VARs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Variance')
hold on
grid
plot(min:step:max, MSEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
xline(sY*N, 'black', {'$$\sigma_Y^2\cdot N$$'}, 'interpreter', 'latex');
title("Arithmetic Mean")
xlabel({'$$\sigma_W^2$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('Error', 'interpreter', 'latex','FontSize', 18)

titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_Y$$ =', num2str(sY), ' MC = ', num2str(nMC)];
legend('Variance', 'MSE', 'location', 'northeast')
sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig3, 'png')

end
