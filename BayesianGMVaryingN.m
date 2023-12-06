function [] = ...
    BayesianGMVaryingN(min, max, mult, muY, sY, sW, nMC)

assert(min < max, 'min must be lesser than max')

% tests = min * (mult.^(0:(log(max/min)/log(mult)+1)));
tests = logspace(0, 4, 20)
num_tests = length(tests); % Number of iterations

MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);

for i = 1:length(tests)
    N = tests(i);

    %%% EVALUATE FOR CURRENT N
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

end

%%% Compare performances of each estimator when sY varies
fig1 = "MSE varying N";
figure('name', fig1)
semilogx(tests, MSEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
hold on
grid
semilogx(tests, MSEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
titles = [ ' $$\mu_Y$$ = ', num2str(muY), ' $$\sigma^2_Y$$ = ', num2str(sY) ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xline(sW/sY, 'black', {'$$\sigma_W^2/\sigma_Y^2$$'}, 'interpreter', 'latex');
xlabel({'$$N$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)
legend('MMSE', 'Arithmetic Mean', 'location', 'northeast')

saveas(gcf, fig1, 'png')

%%% Compare estimates of each estimator when sY varies
fig2 = "Estimates varying N";
figure('name', fig2)


semilogx(tests, aveY, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean Y')
hold on
grid
semilogx(tests, AVEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of MMSE estimation')
semilogx(tests, AVEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Mean of Arithmetic Mean estimation')
semilogx(tests, muY*ones(1,num_tests), '--', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Real mean of Y')
axis([min, max, muY-3, muY+3])
titles = [ ' $$\mu_Y$$ = ', num2str(muY), ' $$\sigma^2_Y$$ = ', num2str(sY) ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xline(sW/sY, 'black', {'$$\sigma_W^2/\sigma_Y^2$$'}, 'interpreter', 'latex');
xlabel({'$$N$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('$$\hat Y$$', 'interpreter', 'latex','FontSize', 18)
legend('Mean of Y', 'MMSE', 'Arithmetic Mean', 'location', 'northeast')

saveas(gcf, fig2, 'png')

%%% Compares the theoretical error of each estimator versus the MSE
fig3 = "Error comparing varying N";
figure('Name', fig3)

subplot(2, 1, 1)
semilogx(tests, VARs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Variance')
hold on
grid
semilogx(tests, MSEs_MMSE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
xline(sW/sY, 'black', {'$$\sigma_W^2/\sigma_Y^2$$'}, 'interpreter', 'latex');
title("MMSE")
xlabel({'$$N$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('Error', 'interpreter', 'latex','FontSize', 18)
legend('Variance', 'MSE', 'location', 'northeast')


subplot(2, 1, 2)
semilogx(tests, VARs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Variance')
hold on
grid
semilogx(tests, MSEs_AVE, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
title("Arithmetic Mean")
xlabel({'$$N$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('Error', 'interpreter', 'latex','FontSize', 18)
xline(sW/sY, 'black', {'$$\sigma_W^2/\sigma_Y^2$$'}, 'interpreter', 'latex');
titles = [ ' $$\mu_Y$$ = ', num2str(muY), ' $$\sigma^2_Y$$ = ', num2str(sY) ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
legend('Variance', 'MSE', 'location', 'northeast')
sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig3, 'png')


end

