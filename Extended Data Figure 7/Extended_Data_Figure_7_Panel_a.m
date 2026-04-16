function Extended_Data_Figure_7_Panel_a

filename="Optimal_t_vs_u.txt";
matrix = dlmread(filename);

w=matrix;
U = w(1,:);
Optimal_t= w(2,:);

blue = [0, 92, 171] / 256;
tick_font_size=17;
label_font_size=19;


figure;
plot(U, Optimal_t, '.', ...
     'Color', blue, ...
     'MarkerSize', 14);

set(gca, 'FontSize', tick_font_size);
xlabel('Mutation rate, $\mu$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Optimal rescaled duration, ${\it t^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');

pbaspect([1 1 1]);

ytickformat('%.2f');

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

ax.ZTick = -3:1:3;
ytickformat('%d');    
ax = gca;
ax.YTick = unique(round(ax.YTick));
tickValues = ax.YTick;
newLabels = cell(size(tickValues));
for i = 1:length(tickValues)
    y_val = tickValues(i);
    newLabels{i} = ['10^{' num2str(y_val) '}'];
end
ax.YTickLabel = newLabels;
ax.TickLabelInterpreter = 'tex';  
