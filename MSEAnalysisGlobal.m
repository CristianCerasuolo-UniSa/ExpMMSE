function [] = MSEAnalysisGlobal(nMC)

muY= 0;

blue = [0 0.4470 0.7410];
red = [0.9290 0.6940 0.1250];
yellow = [0.4940 0.1840 0.5560];
violet = (1/255)*[102 255 178];
darkgreen = [0, 0.5, 0];

%% Varying sY

num_tests = 20;
tests = logspace(-1, 4, num_tests);
sW = 1000;
N = 10;


MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);


for i = 1:num_tests

    %%% EVALUATE FOR CURRENT sY
    [meanMMSE, meanAVE, mseMMSE, mseAVE, varAVE, varMMSE, Y] = ...
    BayesianGM(N, muY, tests(i), sW, nMC);

    %%% STORE MSE AND PREDICTION MADE BY EACH ESTIMATOR
    MSEs_MMSE(i) = mseMMSE;
    MSEs_AVE(i) = mseAVE;

    AVEs_MMSE(i) = meanMMSE;
    AVEs_AVE(i) = meanAVE;
    aveY(i) = mean(Y); % Y is the vector of sampled y for each MC

    VARs_AVE(i) = varAVE;
    VARs_MMSE(i) = varMMSE;
end

name = "Analysis of MSE varying prior variance";
figure('name', name)

semilogx(tests, MSEs_MMSE, '-o','color', blue,'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
hold on
grid
semilogx(tests, MSEs_AVE, '-o','color', red,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
semilogx(tests, tests, '-o','color', yellow,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Only prior (no data)')
semilogx(tests, VARs_MMSE, '-o', 'color', darkgreen, 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Theroetical error of MMSE')
xline(sW/N, 'black', {'$$\sigma_W^2/N$$'}, 'interpreter', 'latex', 'DisplayName', '');
axis([min(tests), max(tests), min(MSEs_MMSE), 2*(sW/N)])
legend('location', 'northeast')
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_Y$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)

saveas(gcf, name, 'png')

%% Varying sW/N

num_tests = 20;
sY = 1;
N = 1000;
tests = logspace(1, 7, num_tests)/N;

MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);


for i = 1:num_tests

    %%% EVALUATE FOR CURRENT sY
    [meanMMSE, meanAVE, mseMMSE, mseAVE, varAVE, varMMSE, Y] = ...
    BayesianGM(N, muY, sY, tests(i), nMC);

    %%% STORE MSE AND PREDICTION MADE BY EACH ESTIMATOR
    MSEs_MMSE(i) = mseMMSE;
    MSEs_AVE(i) = mseAVE;

    AVEs_MMSE(i) = meanMMSE;
    AVEs_AVE(i) = meanAVE;
    aveY(i) = mean(Y); % Y is the vector of sampled y for each MC

    VARs_AVE(i) = varAVE;
    VARs_MMSE(i) = varMMSE;
end

name = "Analysis of MSE varying sW divided by N";
figure('name', name)

semilogx(tests, MSEs_MMSE, '-o','color', blue,'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
hold on
grid
semilogx(tests, MSEs_AVE, '-o','color', red,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
semilogx(tests, tests, '-o','color', yellow,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Only prior (no data)')
semilogx(tests, VARs_MMSE, '-o', 'color', darkgreen, 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Theroetical error of MMSE')
xline(sY, 'black', {'$$\sigma_Y^2$$'}, 'interpreter', 'latex', 'DisplayName', 'Prior variance');
axis([min(tests), max(tests), min(MSEs_MMSE), 2*(max(tests)/N)])
legend('location', 'northeast')
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_Y$$ =', num2str(sY), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_W/N$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)

saveas(gcf, name, 'png')


%% Varying N

num_tests = 20;
tests = round(logspace(0, 4, num_tests));
sW = 1000;
sY = 10;


MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);


for i = 1:num_tests

    %%% EVALUATE FOR CURRENT sY
    [meanMMSE, meanAVE, mseMMSE, mseAVE, varAVE, varMMSE, Y] = ...
    BayesianGM(tests(i), muY, sY, sW, nMC);

    %%% STORE MSE AND PREDICTION MADE BY EACH ESTIMATOR
    MSEs_MMSE(i) = mseMMSE;
    MSEs_AVE(i) = mseAVE;

    AVEs_MMSE(i) = meanMMSE;
    AVEs_AVE(i) = meanAVE;
    aveY(i) = mean(Y); % Y is the vector of sampled y for each MC

    VARs_AVE(i) = varAVE;
    VARs_MMSE(i) = varMMSE;
end

name = "Analysis of MSE varying number of samples";
figure('name', name)

loglog(tests, MSEs_MMSE, '-o','color', blue,'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
hold on
grid
loglog(tests, MSEs_AVE, '-o','color', red,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
%loglog(tests, tests, '-o','color', yellow,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Only prior (no data)')
%loglog(tests, VARs_MMSE, '-o', 'color', darkgreen, 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Theroetical error of MMSE')
axis([min(tests), max(tests), min(MSEs_MMSE), (sW/min(tests))])
legend('location', 'northeast')
titles = [ '$$\sigma_Y^2$$ = ', num2str(sY), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_W$$ =', num2str(sW), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$N$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)

saveas(gcf, name, 'png')

%% Varying sW

num_tests = 20;
sY = 1;
N = 1000;
tests = logspace(1, 7, num_tests);

MSEs_MMSE = zeros(num_tests, 1);
MSEs_AVE = zeros(num_tests, 1);

AVEs_AVE = zeros(num_tests, 1);
AVEs_MMSE = zeros(num_tests, 1);

VARs_AVE = zeros(num_tests, 1);
VARs_MMSE = zeros(num_tests, 1);


for i = 1:num_tests

    %%% EVALUATE FOR CURRENT sY
    [meanMMSE, meanAVE, mseMMSE, mseAVE, varAVE, varMMSE, Y] = ...
    BayesianGM(N, muY, sY, tests(i), nMC);

    %%% STORE MSE AND PREDICTION MADE BY EACH ESTIMATOR
    MSEs_MMSE(i) = mseMMSE;
    MSEs_AVE(i) = mseAVE;

    AVEs_MMSE(i) = meanMMSE;
    AVEs_AVE(i) = meanAVE;
    aveY(i) = mean(Y); % Y is the vector of sampled y for each MC

    VARs_AVE(i) = varAVE;
    VARs_MMSE(i) = varMMSE;
end

name = "Analysis of MSE varying sW divided by N";
figure('name', name)

semilogx(tests, MSEs_MMSE, '-o','color', blue,'markersize', 10, 'linewidth', 2, 'DisplayName', 'MMSE')
hold on
grid
semilogx(tests, MSEs_AVE, '-o','color', red,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
semilogx(tests, tests, '-o','color', yellow,'markersize', 10, 'linewidth', 2, 'DisplayName', 'Only prior (no data)')
semilogx(tests, VARs_MMSE, '-o', 'color', darkgreen, 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Theroetical error of MMSE')
axis([min(tests), max(tests), min(MSEs_MMSE), 2*(max(tests)/N)])
legend('location', 'northeast')
titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
    ' $$\sigma^2_Y$$ =', num2str(sY), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma^2_W$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)

saveas(gcf, name, 'png')



end

