function Supplementary_Figure_5_Panel_b

filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_t_1.txt';
L = dlmread(filename);

t = -1:0.04:3;   % Exponent of t

Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);

%%  Calculate the derivative of \bar{p} 
dQs_Ulti = (-2*Lambda_static(1,:) + 2*Lambda_static(2,:) - Lambda_static(3,:)) / 24;
dQd_Ulti = (-2*Lambda_dynamic(1,:) + 2*Lambda_dynamic(2,:) - Lambda_dynamic(3,:)) / 24;

delta = 0.0025;   % Selection intensity

%%  Calculate $\bar{p} 
Qs_Ulti = 0.5 + delta * dQs_Ulti;
Qd_Ulti = 0.5 + delta * dQd_Ulti;

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;


figure;
plot(t, Qd_Ulti, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot(t, Qs_Ulti, 'Color', red, 'LineWidth', 2.5);

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
ylabel('Rejection threshold, $\bar{q}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
ytickformat('%.4f');
axis([-1 3 0.4943 0.4967]);