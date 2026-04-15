function Extended_Data_Figure_5_Panel_d


filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_t_add.txt';
L = dlmread(filename);

t = -1:0.03:2.99;   % Exponent of t

Ls = L(1:3, :);   % Structure coefficients of static counterparts
L_add = L(4:6, :);  % Structure coefficients of aggregated static networks (weighted networks)
L_max = L(7:9, :);  % Structure coefficients of aggregated static networks (unweighted networks)
Ld = L(10:12, :);  % Structure coefficients of dynamic networks


%%  Calculate the derivative of \bar{p} 
B = 1.5;
dPs_Trust = ( (B - 1)*2 * Ls(1,:) - 2 * Ls(2,:) + (B-2) * Ls(3,:) ) / 24;
dPd_Trust = ( (B - 1)*2 * Ld(1,:) - 2 * Ld(2,:) + (B-2) * Ld(3,:) ) / 24;
dP_add_Trust = ( (B - 1)*2 * L_add(1,:) - 2 * L_add(2,:) + (B-2) * L_add(3,:) ) / 24;
dP_max_Trust = ( (B - 1)*2 * L_max(1,:) - 2 * L_max(2,:) + (B-2) * L_max(3,:) ) / 24;

delta = 0.0025;  % Selection intensity

%% Calculate \bar{p}
Ps_Trust = 0.5 + delta * dPs_Trust;
Pd_Trust = 0.5 + delta * dPd_Trust;
P_add_Trust = 0.5 + delta * dP_add_Trust;
P_max_Trust = 0.5 + delta * dP_max_Trust;

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
green = [0, 158, 115] / 256;


figure;
plot(t, Pd_Trust, 'Color', blue,  'LineWidth', 2.5);
hold on;
plot(t, Ps_Trust, 'Color', red, 'LineWidth', 2.5);
hold on;
plot(t, P_add_Trust, 'Color', green, 'LineWidth', 2.5);
hold on;
plot(t, P_max_Trust, 'Color', green, 'LineStyle','--', 'LineWidth', 2.5);

axis([-1 3 0.45 0.485]);
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
ylabel('Trust, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size); 

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
yticks([0.45, 0.46, 0.47, 0.48]); 
ytickformat('%.2f');

legend('Static', 'Dynamic', 'Aggregate 1', 'Aggregate 2');
legend('FontSize', 17);
legend('box', 'off');