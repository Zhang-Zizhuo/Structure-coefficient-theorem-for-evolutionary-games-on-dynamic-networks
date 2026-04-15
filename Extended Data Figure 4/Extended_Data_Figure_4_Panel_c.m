function Extended_Data_Figure_4_Panel_c

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



% -------- Ultimatum game --------
dPs_Ulti = (Lambda_static_1 - Lambda_static_2) / 12;
dPd_Ulti = (Lambda_dynamic_1 - Lambda_dynamic_2) / 12;

% -------- Convert the derivatives to actual levels --------
delta = 0.0025;  % Selection intensity

Ps_Ulti  = 0.5 + delta * dPs_Ulti;
Pd_Ulti  = 0.5 + delta * dPd_Ulti;




figure;
hold on;

surf(X, Y, Pd_Ulti, ...
    'FaceColor', blue, ...
    'FaceAlpha', Blue_alpha, ...
    'EdgeColor', 'none');

surf(X, Y, Ps_Ulti, ...
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
axis([-3.00 0.00 -3.00 0.00 0.4999 0.5008]);
ytickformat('%d');   
ax = gca;
ax.YTick = unique(ax.YTick);

ytickformat('%d');   
ax = gca;
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

xlabel('$q_{12}$', 'Interpreter', 'latex', 'FontSize', 18);  
ylabel('$q_{21}$', 'Interpreter', 'latex', 'FontSize', 18);  
zlabel('Fairness, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', 18);

