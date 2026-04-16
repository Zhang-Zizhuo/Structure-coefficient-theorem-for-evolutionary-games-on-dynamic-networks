function Extended_Data_Figure_4_Panel_d


red  = [185, 48, 64] / 255;   
blue = [42, 98, 176] / 255;   
Blue_alpha = 0.5;
Red_alpha = 0.3;


filename = 'Core_Periphery_Lambda_vs_q12.txt';
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

% -------- Trust game --------
B = 1.5;
dPs_Trust = ( (B - 1)*2 * Lambda_static_1 - 2 * Lambda_static_2 + (B - 2) * Lambda_static_3 ) / 24;
dPd_Trust = ( (B - 1)*2 * Lambda_dynamic_1 - 2 * Lambda_dynamic_2 + (B - 2) * Lambda_dynamic_3 ) / 24;

% -------- Convert the derivatives to actual levels --------
delta = 0.0025;  % Selection intensity

Ps_Trust = 0.5 + delta * dPs_Trust;
Pd_Trust = 0.5 + delta * dPd_Trust;



figure;
hold on;

surf(X, Y, Pd_Trust, ...
    'FaceColor', blue, ...
    'FaceAlpha', Blue_alpha, ...
    'EdgeColor', 'none');

surf(X, Y, Ps_Trust, ...
    'FaceColor', red, ...
    'FaceAlpha', Red_alpha, ...
    'EdgeColor', 'none');

box on;
grid on;
view(45, 30);

set(gca, 'FontSize', 13, 'LineWidth', 1.2);

xticks(-3:1:0);
yticks(-3:1:0);

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

axis([-3 0 -3 0 0.4918 0.4927]);
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
ztickformat('%.4f');

tick_font_size=14;
set(gca, 'FontSize', tick_font_size);

set(gcf, 'Color', 'w');
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);

ax = gca;
ax.Position = [0.13 0.11 0.775 0.815];  

xlabel('$q_{12}$', 'Interpreter', 'latex', 'FontSize', 18);  
ylabel('$q_{21}$', 'Interpreter', 'latex', 'FontSize', 18);  
zlabel('Trust, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', 18);
