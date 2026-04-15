function Extended_Data_Figure_7_Panel_c

filename="C:\Users\Lenovo\Desktop\Optimal_Gamma_t_Gold_for_k.txt";
matrix = dlmread(filename);

Ks = matrix(1,:);
Optimal_t= matrix(2,:);

blue = [0, 92, 171] / 256;
tick_font_size=17;
label_font_size=19;

figure;
plot(Ks, Optimal_t, '.', ...
     'Color', blue, ...
     'MarkerSize', 14);

set(gca, 'FontSize', tick_font_size);
xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Optimal rescaled duration, ${\it t^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w'); 

pbaspect([1 1 1]);

axis([0 100 0.69 0.95]);
yticks(0.7:0.1:0.9); 
ytickformat('%.2f');

ax = gca;
tickValues = ax.YTick;
newLabels = cell(size(tickValues));
for i = 1:length(tickValues)
    y_val = tickValues(i);
    newLabels{i} = ['10^{' num2str(y_val,'%.1f') '}'];
end
ax.YTickLabel = newLabels;
ax.TickLabelInterpreter = 'tex';  
