function Supplementary_Figure_3_Panel_d

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;

filename = 'C:\Users\Lenovo\Desktop\结果TXT\SF_Periphery_Parameter_t.txt';
L = dlmread(filename);

t = -1:0.04:3;  %% Exponent of t

Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of \bar{p}
dP_static_Dic = ( -2 * Lambda_static(2,:) - Lambda_static(3,:) ) / 12;
dP_dynamic_Dic = ( -2 * Lambda_dynamic(2,:) - Lambda_dynamic(3,:) ) / 12;

delta = 0.0025;  %%  Selection intensity

%%  Calculate \bar{p}
P_static_Dic = 0.5 + delta * dP_static_Dic;
P_dynamic_Dic = 0.5 + delta * dP_dynamic_Dic;

tick_font_size=18;
label_font_size=21;



figure;
plot(t, P_dynamic_Dic, 'Color', blue,  'LineWidth', 2.5);
hold on;
plot(t, P_static_Dic, 'Color', red, 'LineWidth', 2.5);
axis([-1 3 0.394 0.410]);
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

xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Altruism, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);

xtickangle(0);

