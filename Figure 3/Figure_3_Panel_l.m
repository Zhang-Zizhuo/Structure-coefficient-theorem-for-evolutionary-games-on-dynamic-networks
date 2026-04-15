function Figure_3_Panel_l


filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_u (t=10).txt';
L = dlmread(filename);

u = -3:0.03:0;  % Exponent of u

Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of the indicators \bar{p} with respect to \delta
B = 1.5;
dPs_Trust = ( (B - 1)*2 * Lambda_static(1,:) - 2 * Lambda_static(2,:) + (B-2) * Lambda_static(3,:) ) / 24;
dPd_Trust = ( (B - 1)*2 * Lambda_dynamic(1,:) - 2 * Lambda_dynamic(2,:) + (B-2) * Lambda_dynamic(3,:) ) / 24;

delta = 0.0025;   %% Selection intensity

%%  Calculate $\bar{p} 
Ps_Trust = 0.5 + delta * dPs_Trust;
Pd_Trust = 0.5 + delta * dPd_Trust;


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;



figure;
plot(u, Pd_Trust, 'Color', blue,  'LineWidth', 2.5);
hold on;
plot(u, Ps_Trust, 'Color', red, 'LineWidth', 2.5);

xtickformat('%d');   

ax = gca;
ax.XTick = unique(round(ax.XTick));

ax = gca;
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
ytickformat('%.2f');


xtickangle(0);




