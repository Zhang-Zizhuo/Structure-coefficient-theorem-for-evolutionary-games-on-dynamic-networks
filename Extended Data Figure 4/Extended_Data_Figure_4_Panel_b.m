function Extended_Data_Figure_4_Panel_b


red  = [185, 48, 64] / 255;   
blue = [42, 98, 176] / 255;   
Blue_alpha = 0.5;
Red_alpha = 0.3;

filename = 'C:\Users\Lenovo\Desktop\结果TXT\CP_q12.txt';
L = dlmread(filename);


Gamma12_all = L(:,1);
Gamma21_all = L(:,2);

Lambda_static_1_all = L(:,5);
Lambda_static_2_all = L(:,6);
Lambda_static_3_all = L(:,7);

Lambda_dynamic_1_all = L(:,8);
Lambda_dynamic_2_all = L(:,9);
Lambda_dynamic_3_all = L(:,10);



Gamma12 = unique(Gamma12_all);
Gamma21 = unique(Gamma21_all);

nq12 = length(Gamma12);
nq21 = length(Gamma21);

[X, Y] = meshgrid(Gamma12, Gamma21);  


Lambda_static_1 = reshape(Lambda_static_1_all, nq21, nq12);
Lambda_static_2 = reshape(Lambda_static_2_all, nq21, nq12);
Lambda_static_3 = reshape(Lambda_static_3_all, nq21, nq12);

Lambda_dynamic_1 = reshape(Lambda_dynamic_1_all, nq21, nq12);
Lambda_dynamic_2 = reshape(Lambda_dynamic_2_all, nq21, nq12);
Lambda_dynamic_3 = reshape(Lambda_dynamic_3_all, nq21, nq12);



% -------- Dictator game --------
dPs_Dic = (-2 * Lambda_static_2 - Lambda_static_3) / 12;
dPd_Dic = (-2 * Lambda_dynamic_2 - Lambda_dynamic_3) / 12;

% -------- Convert the derivatives to actual levels --------
delta = 0.0025;  % Selection intensity

Ps_Dic   = 0.5 + delta * dPs_Dic;
Pd_Dic   = 0.5 + delta * dPd_Dic;



figure;
hold on;

surf(X, Y, Pd_Dic, ...
    'FaceColor', blue, ...
    'FaceAlpha', Blue_alpha, ...
    'EdgeColor', 'none');

surf(X, Y, Ps_Dic, ...
    'FaceColor', red, ...
    'FaceAlpha', Red_alpha, ...
    'EdgeColor', 'none');

box on;
grid on;
view(45, 30);

set(gca, 'FontSize', 13, 'LineWidth', 1.2);

xtickformat('%d');   
ax = gca;
ax.XTick = unique(round(ax.XTick));
tickValues = ax.XTick;

newLabels = cell(size(tickValues));
for i = 1:length(tickValues)
    x_val = tickValues(i);
    newLabels{i} = ['10^{' num2str(x_val) '}'];
end

ax.XTickLabel = newLabels;
ax.TickLabelInterpreter = 'tex'; 

axis([-3 0 -3 0 0.4665 0.471]);

ytickformat('%d');   
ax = gca;
ax.YTick = unique(ax.YTick);

ytickformat('%d');  

tickValues = ax.YTick;

newLabels = cell(size(tickValues));
for i = 1:length(tickValues)
    y_val = tickValues(i);
    newLabels{i} = ['10^{' num2str(y_val) '}'];
end
ax.YTickLabel = newLabels;
ax.TickLabelInterpreter = 'tex'; 
ztickformat('%.3f');

tick_font_size=14;
set(gca, 'FontSize', tick_font_size);

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);

xlabel('$q_{12}$', 'Interpreter', 'latex', 'FontSize', 18);  
ylabel('$q_{21}$', 'Interpreter', 'latex', 'FontSize', 18);  
zlabel('Altruism, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', 18);


