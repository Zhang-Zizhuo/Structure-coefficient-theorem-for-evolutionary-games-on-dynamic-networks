function Extended_Data_Figure_3_Panel_c


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;

filename = 'C:\Users\Lenovo\Desktop\结果TXT\CP_Average_Parameter_u (t=10).txt';
L = dlmread(filename);

u = -3:0.04:0;   % Exponent of u
Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of \bar{p}
dP_static_Ulti = ( Lambda_static(1,:) - Lambda_static(2,:) ) / 12;
dP_dynamic_Ulti = ( Lambda_dynamic(1,:) - Lambda_dynamic(2,:) ) / 12;

delta = 0.005;  %%  Selection intensity

%% Calculate \bar{p}
P_static_Ulti = 0.5 + delta * dP_static_Ulti;
P_dynamic_Ulti = 0.5 + delta * dP_dynamic_Ulti;

tick_font_size=18;
label_font_size=21;


figure;
plot(u, P_dynamic_Ulti, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot(u, P_static_Ulti, 'Color', red, 'LineWidth', 2.5);

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

xlabel('Mutation rate, $\mu$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Fainess, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size); 

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w'); 

pbaspect([1 1 1]);
axis([-3 0 0.4999 0.50012]);
yticks([0.4999, 0.500, 0.5001]); 
ytickformat('%.4f');

xtickangle(0);
