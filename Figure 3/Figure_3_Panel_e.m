function Figure_3_Panel_e

filename = 'Core_Periphery_Lambda_vs_t.txt';
L = dlmread(filename);

t = -1:0.04:3;   %  Index

Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of the indicators \bar{p} with respect to \delta
dPs_Dic = ( -2 * Lambda_static(2,:) - Lambda_static(3,:) ) / 12;
dPd_Dic = ( -2 * Lambda_dynamic(2,:) - Lambda_dynamic(3,:) ) / 12;

delta = 0.0025;   %% Selection intensity

%%  Calculate $\bar{p} 
Ps_Dic = 0.5 + delta * dPs_Dic;
Pd_Dic = 0.5 + delta * dPd_Dic;


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;


figure;
plot(t, Pd_Dic, 'Color', blue,  'LineWidth', 2.5);
hold on;
plot(t, Ps_Dic, 'Color', red, 'LineWidth', 2.5);

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

set(gca, 'FontSize', tick_font_size);


xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Altruism, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size); 

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);

axis([-1 3 0.409 0.424]);
yticks([0.41, 0.42]); 
ytickformat('%.2f');


xtickangle(0);































