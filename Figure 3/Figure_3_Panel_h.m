function Figure_3_Panel_h

filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_t_1.txt';

L = dlmread(filename);

t = -1:0.04:3;  %%  Exponent of t

Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of the indicators \bar{p} with respect to \delta
dPs_Ulti = ( Lambda_static(1,:) - Lambda_static(2,:) ) / 12;
dPd_Ulti = ( Lambda_dynamic(1,:) - Lambda_dynamic(2,:) ) / 12;

delta = 0.0025;   %% Selection intensity

%%  Calculate $\bar{p} 
Ps_Ulti = 0.5 + delta * dPs_Ulti;
Pd_Ulti = 0.5 + delta * dPd_Ulti;



red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;


figure;
plot(t, Pd_Ulti, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot(t, Ps_Ulti, 'Color', red, 'LineWidth', 2.5);

axis([-1 3 0.500 0.5014]);
yticks([0.5 0.501 0.502]);
ytickformat('%.3f');

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


xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % x 轴标签
ylabel('Fainess, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % y 轴标签

set(gcf, 'Color', 'w'); 
set(gca, 'Color', 'w'); 

pbaspect([1 1 1]);

xtickangle(0);








