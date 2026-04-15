function Extended_Data_Figure_3_Panel_d

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;

filename = 'C:\Users\Lenovo\Desktop\结果TXT\CP_Average_Parameter_u (t=10).txt';
L = dlmread(filename);

u = -3:0.04:0;   % Exponent of u
Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of \bar{p}
B = 1.5;
dP_static_Trust = ( (B - 1)*2 * Lambda_static(1,:) - 2 * Lambda_static(2,:) + (B-2) * Lambda_static(3,:) ) / 24;
dP_dynamic_Trust = ( (B - 1)*2 * Lambda_dynamic(1,:) - 2 * Lambda_dynamic(2,:) + (B-2) * Lambda_dynamic(3,:) ) / 24;

delta = 0.005;  %%  Selection intensity


P_static_Trust = 0.5 + delta * dP_static_Trust;
P_dynamic_Trust = 0.5 + delta * dP_dynamic_Trust;


tick_font_size=18;
label_font_size=21;


figure;
plot(u, P_dynamic_Trust, 'Color', blue,  'LineWidth', 2.5);
hold on;
plot(u, P_static_Trust, 'Color', red, 'LineWidth', 2.5);


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

xlabel('Mutation rate, $\mu$', 'Interpreter', 'latex', 'FontSize', label_font_size); 
ylabel('Trust, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
yticks([0.48, 0.49, 0.50]); 
ytickformat('%.2f');