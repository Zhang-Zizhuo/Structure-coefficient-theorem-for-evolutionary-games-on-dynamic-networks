function Extended_Data_Figure_5_Panel_b


filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_t_add.txt';
L = dlmread(filename);

t = -1:0.03:2.99;   % Exponent of t

Ls = L(1:3, :);   % Structure coefficients of static counterparts
L_add = L(4:6, :);  % Structure coefficients of aggregated static networks (weighted networks)
L_max = L(7:9, :);  % Structure coefficients of aggregated static networks (unweighted networks)
Ld = L(10:12, :);  % Structure coefficients of dynamic networks

%%  Calculate the derivative of \bar{p} 
dPs_Dic = ( -2 * Ls(2,:) - Ls(3,:) ) / 12;
dPd_Dic = ( -2 * Ld(2,:) - Ld(3,:) ) / 12;
dP_add_Dic = ( -2 * L_add(2,:) - L_add(3,:) ) / 12;
dP_max_Dic = ( -2 * L_max(2,:) - L_max(3,:) ) / 12;

delta = 0.0025;  % Selection intensity

%% Calculate \bar{p}
Ps_Dic = 0.5 + delta * dPs_Dic;
Pd_Dic = 0.5 + delta * dPd_Dic;
P_add_Dic = 0.5 + delta * dP_add_Dic;
P_max_Dic = 0.5 + delta * dP_max_Dic;

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
green = [0, 158, 115] / 256;


figure;
plot(t, Ps_Dic, 'Color', red, 'LineWidth', 2.5);
hold on;
plot(t, P_add_Dic, 'Color', green, 'LineWidth', 2.5);
hold on;
plot(t, P_max_Dic, 'Color', green, 'LineStyle','--', 'LineWidth', 2.5);
hold on;
plot(t, Pd_Dic, 'Color', blue,  'LineWidth', 2.5);
hold on;

axis([-1 3 0.30 0.45]);

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
tick_font_size=17.5;

set(gca, 'FontSize', tick_font_size);

label_font_size=21;

xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Altruism, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
yticks([0.30, 0.35, 0.40, 0.45]); 
ytickformat('%.2f');

legend('Static', 'Dynamic', 'Aggregate 1', 'Aggregate 2');
legend('FontSize', 17);
legend('box', 'off');
