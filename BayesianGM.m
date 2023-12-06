function [meanMMSE, meanAVE, mseMMSE, mseAVE, varAVE, varMMSE, Y] = ...
    BayesianGM(N, muY, sY, sW, nMC)


% Assuming that Y and W_i are independent, we can say that X_i = Y + W_i
% will have a variance sX = sY + sW and a mean equal to muX = muY if W_i
% are zero-mean error

% sX = sY + sW;

for ii=1:nMC
    %%% GENERATE y from Y~N(muy, sy)
    Y(ii) = normrnd(muY, sqrt(sY), 1);

    %%% GENERATE THE ERROR W AND THEN X
    w = normrnd(0, sqrt(sW), 1, N);

    x = Y(ii) + w; 

    %%% ESTIMATES THE VALUE OF y
    AVE(ii) = mean(x);
    MMSE(ii) = mean(x) * sY/(sY+sW/N);
    
end

%%% CHECK UNBIASEDNESS -> It should be near to muY
meanMMSE = mean(MMSE);
meanAVE = mean(AVE);

%%% COMPUTE MSE ~ E[Y-g(x)^2]
mseMMSE = mean((Y - MMSE).^2);
mseAVE = mean((Y - AVE).^2);

%%% COMPUTE ERROR
varAVE = sW/N;
varMMSE = (sY*sW)/(sW+sY*N);


% 
% figure
% subplot(2,1,1)
% plot(1:nMC, MMSE, '-bo', ...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% hold on
% plot(1:nMC, muY*ones(1, nMC), '--r', ...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% xlabel('MC runs', 'fontsize', 18)
% ylabel('MMSE', 'fontsize',18)
% grid
% axis([1 nMC muY-3 muY+3])
% 
% 
% subplot(2,1,2)
% plot(1:nMC, AVE, '-bo', ...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% hold on
% plot(1:nMC, muY*ones(1, nMC), '--r', ...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% xlabel('MC runs', 'fontsize', 18)
% ylabel('Arithmetic Mean', 'fontsize',18)
% grid
% axis([1 nMC muY-3 muY+3])
% titles = [ '$$N$$ = ', num2str(N), ' $$\mu_Y$$ = ', num2str(muY), ...
%     ' $$\sigma^2_Y$$ = ', num2str(sY), ' $$\sigma^2_W$$ =', num2str(sW), ...
%     ' MC = ', num2str(nMC)];
% sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)



end

