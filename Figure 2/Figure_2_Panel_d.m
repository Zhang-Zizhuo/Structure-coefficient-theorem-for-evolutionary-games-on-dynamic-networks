function Figure_2_Panel_d

filename = "C:\Users\Lenovo\Desktop\Network\Merged_All.txt";

L = dlmread(filename);

T_index = 3;    %  T_index = 1 means inter-network transition probabilities q_{12} = q_{21} = 10^{-4}   
                %  T_index = 2 means inter-network transition probabilities q_{12} = q_{21} = 10^{-2} 
                %  T_index = 3 means inter-network transition probabilities q_{12} = q_{21} = 1  

SZ = 20000;  % Number of data points 

cb = zeros(2, SZ);  %% (c/b)* for cooperation

for iter = 1:SZ 
    L_vec = L(:, iter);
    Lambda_static = L_vec(1:3);
    t_start = 1 + 3*T_index; 
    t_end = t_start + 2; 
    Lambda_dynamic = L_vec(t_start:t_end);

    K1 = sum(Lambda_static);
    K2 = Lambda_static(1) - Lambda_static(2);
    cb_static = K2 / K1 ;

    K1 = sum(Lambda_dynamic);
    K2 = Lambda_dynamic(1) - Lambda_dynamic(2);
    cb_dynamic = K2 / K1;

    cb(1, iter) = cb_static;
    cb(2, iter) = cb_dynamic;

end

idx{1}  = 1:2000;      % ER
idx{2}  = 2001:4000;    % SF
idx{3}  = 4001:6000;    % WS
idx{4}  = 6001:8000;    % RN
idx{5}  = 8001:10000;    % HK
idx{6}  = 10001:12000;    % KE
idx{7}  = 12001:14000;    % Shifted
idx{8}  = 14001:16000;    % FF
idx{9}  = 16001:18000;    %  Island BA
idx{10} = 18001:20000;    %  Island ER
colors = [
    0.12 0.47 0.71   
    0.20 0.63 0.17   
    0.89 0.10 0.11   
    1.00 0.50 0.00   
    0.42 0.24 0.60   
    0.65 0.34 0.16   
    0.50 0.50 0.50   
    0.30 0.75 0.93   
    0.85 0.33 0.10   
    0.60 0.60 0.20   
];

figure('Color','w');
hold on;

marker_size = 4;
alpha_val   = 0.6;
Figure_Font_Size = 18;
Legend_TXT_Size = 17;




for k = 1:10
    scatter( ...
        cb(1, idx{k}), ...   % static
        cb(2, idx{k}), ...   % dynamic
        marker_size, ...
        colors(k,:), ...
        'filled', ...
        'MarkerFaceAlpha', alpha_val ...
    );
end

% y = x line
xlim auto; ylim auto;
lims = [min(xlim) max(xlim)];
plot(lims, lims, '--', 'Color',[0.3 0.3 0.3], 'LineWidth',1.5);

xtickformat('%.1f');
ytickformat('%.1f');
axis([-0.1 0.56 -0.1 0.56]);

set(gca, ...
    'FontSize', Figure_Font_Size, ...
    'LineWidth', 1.2, ...
    'TickDir', 'out');

ax = gca;

box on;
ax.TickDir = 'in';         
ax.TickLength = [0.01 0.01]; 
ax.Layer = 'top';        

title('Cooperation', 'FontSize', 16);
xlabel('$(c/b)^*$ for static', 'FontSize', 21, 'Interpreter','latex');
ylabel('$(c/b)^*$ for dynamic', 'FontSize', 21, 'Interpreter','latex');

legend({'ER','SF','RR','WS','HK', 'KE', 'Shifted', 'FF', 'Island BA', 'Island ER'}, ...
    'Location','northwest', ...
    'NumColumns',2, ...
    'FontSize',Legend_TXT_Size);
legend('box', 'off');
axis square;

