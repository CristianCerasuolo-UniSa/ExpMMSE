function [] = ...
    BayesianGMVaryingSY(min, max, step, N, muY, sW, nMC)

%%% Varying the variance of the Y variable, plot the MSE, the estimates
%%% made by each estimator and the comparison between MSE and theoretical
%%% error

assert(min < max, 'min must be lesser than max')

num_tests = (max-min)/step + 1; % Number of iterations

MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);

i = 1;
for sY = min:step:max

    %%% EVALUATE FOR CURRENT sY
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

%%% Compare performances of each estimator when sY varies
fig1 = "MSE varying variance";
figure('name', fig1)
hold on
grid
plot(min:step:max, MSEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
plot(min:step:max, MSEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'AVE')
plot(min:step:max, min:step:max, '--', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Only prior with \mu_Y=0')
xline(sW/N, 'black', {'$$\sigma_W^2/N$$'}, 'interpreter', 'latex');
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_Y$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)
legend('MMSE', 'Arithmetic Mean', 'Only prior with \mu_Y=0', 'location', 'northeast')
axis([min, max, -inf, inf])

saveas(gcf, fig1, 'png')

%%% Compare estimates of each estimator when sY varies
fig2 = "Estimates varying variance";
figure('name', fig2)
hold on
grid

plot(min:step:max, aveY, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Real mean over Y')
plot(min:step:max, AVEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of MMSE estimation')
plot(min:step:max, AVEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of Arithmetic Mean estimation')
plot(min:step:max, muY*ones(num_tests), '--', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of Y')

xline(sW/N, 'black', {'$$\sigma_W^2/N$$'}, 'interpreter', 'latex');
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_Y$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('$$\hat Y$$', 'interpreter', 'latex','FontSize', 18)
legend('Mean of Y', 'MMSE', 'Arithmetic Mean', 'location', 'northeast')
axis([min, max, -inf, inf])

saveas(gcf, fig2, 'png')

%%% Compares the theoretical error of each estimator versus the MSE
fig3 = "Error comparing varying sY";
figure('Name', fig3)

subplot(2, 1, 1)
plot(min:step:max, VARs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Variance')
hold on
grid
plot(min:step:max, MSEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
xline(sW/N, 'black', {'$$\sigma_W^2/N$$'}, 'interpreter', 'latex');
title("MMSE")
xlabel({'$$\sigma_Y^2$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('Error', 'interpreter', 'latex','FontSize', 18)
legend('Variance', 'MSE', 'location', 'northeast')
axis([min, max, -inf, inf])

subplot(2, 1, 2)
plot(min:step:max, VARs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Variance')
hold on
grid
plot(min:step:max, MSEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
xline(sW/N, 'black', {'$$\sigma_W^2/N$$'}, 'interpreter', 'latex');
title("Arithmetic Mean")
xlabel({'$$\sigma_Y^2$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('Error', 'interpreter', 'latex','FontSize', 18)

titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
legend('Variance', 'MSE', 'location', 'northeast')
sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)
axis([min, max, -inf, inf])

saveas(gcf, fig3, 'png')

end

