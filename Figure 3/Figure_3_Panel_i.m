function Figure_3_Panel_i

filename = 'Core_Periphery_Lambda_vs_u_t=10.txt';
L = dlmread(filename);
u = -3:0.03:0;  %% Exponent of u 

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
plot(u, Pd_Ulti, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot(u, Ps_Ulti, 'Color', red, 'LineWidth', 2.5);

yticks([0.5 0.501 0.502]);
ytickformat('%.3f');

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
ylabel('Fainess, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);

xtickangle(0);

