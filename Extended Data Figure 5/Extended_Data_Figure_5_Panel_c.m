function Extended_Data_Figure_5_Panel_c


filename = 'Core_Periphery_vs_Aggregate.txt';
L = dlmread(filename);

t = -1:0.03:2.99;   % Exponent of t

Ls = L(1:3, :);   % Structure coefficients of static counterparts
L_add = L(4:6, :);  % Structure coefficients of aggregated static networks (weighted networks)
L_max = L(7:9, :);  % Structure coefficients of aggregated static networks (unweighted networks)
Ld = L(10:12, :);  % Structure coefficients of dynamic networks

%%  Calculate the derivative of \bar{p} 
dPs_Ulti = ( Ls(1,:) - Ls(2,:) ) / 12;
dPd_Ulti = ( Ld(1,:) - Ld(2,:) ) / 12;
dP_add_Ulti = ( L_add(1,:) - L_add(2,:) ) / 12;
dP_max_Ulti = ( L_max(1,:) - L_max(2,:) ) / 12;

delta = 0.0025;  % Selection intensity

%% Calculate \bar{p}
Ps_Ulti = 0.5 + delta * dPs_Ulti;
Pd_Ulti = 0.5 + delta * dPd_Ulti;
P_add_Ulti = 0.5 + delta * dP_add_Ulti;
P_max_Ulti = 0.5 + delta * dP_max_Ulti;

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
green = [0, 158, 115] / 256;

figure;
plot(t, Pd_Ulti, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot(t, Ps_Ulti, 'Color', red, 'LineWidth', 2.5);
hold on;
plot(t, P_add_Ulti, 'Color', green, 'LineWidth', 2.5);
hold on;
plot(t, P_max_Ulti, 'Color', green, 'LineStyle','--', 'LineWidth', 2.5);

axis([-1 3 0.499 0.5015]);

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
ylabel('Fainess, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
yticks([0.499, 0.500, 0.501]); 
ytickformat('%.3f');

legend('Static', 'Dynamic', 'Aggregate 1', 'Aggregate 2');
legend('FontSize', 17);
legend('box', 'off');
