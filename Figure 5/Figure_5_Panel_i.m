function Figure_5_Panel_i

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;

filename = 'C:\Users\Lenovo\Desktop\RRN_core_Parameter_t.txt';
L = dlmread(filename);

t = -1:0.04:3;  %% Exponent of t

Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of \bar{p}
dP_static_Ulti = ( Lambda_static(1,:) - Lambda_static(2,:) ) / 12;
dP_dynamic_Ulti = ( Lambda_dynamic(1,:) - Lambda_dynamic(2,:) ) / 12;

delta = 0.0025;  %%  Selection intensity

%%  Calculate \bar{p}
P_static_Ulti = 0.5 + delta * dP_static_Ulti;
P_dynamic_Ulti = 0.5 + delta * dP_dynamic_Ulti;

tick_font_size=18;
label_font_size=21;


figure;
plot(t, P_dynamic_Ulti, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot(t, P_static_Ulti, 'Color', red, 'LineWidth', 2.5);

axis([-1 3 0.4999 0.5011]);
yticks([0.5 0.501]);
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

set(gca, 'FontSize', tick_font_size);

xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % x 轴标签
ylabel('Fainess, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % y 轴标签

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
xtickangle(0);

