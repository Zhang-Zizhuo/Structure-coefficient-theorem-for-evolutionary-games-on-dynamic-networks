function Extended_Data_Figure_7_Panel_b

filename="C:\Users\Lenovo\Desktop\Optimal_Gamma_t_Gold.txt";
matrix = dlmread(filename);

w=matrix;
U = w(1,:);

bcd = w(3,:);
bcs = w(4,:);
bcd_fix = w(5, :);

bcd = Log_Mat(bcd);
bcs = Log_Mat(bcs);
bcd_fix = Log_Mat(bcd_fix);


blue = [0, 92, 171] / 256;
red = [200, 40, 40] / 256;
green = [0, 140, 90] / 256;

tick_font_size=17;
label_font_size=19;


figure;
plot(U, bcd, '.', ...
     'Color', green, ...
     'MarkerSize', 12);
hold on;
plot_with_breaks(U, bcs, 'Color', red, 'LineWidth', 2.5);
hold on;
plot_with_breaks(U, bcd_fix, 'Color', blue, 'LineWidth', 2.5);

set(gca, 'FontSize', tick_font_size);

y0_color = [0.5 0.5 0.5]; 
y0_linewidth = 0.8; 
yline(0, 'Color', y0_color, 'LineWidth', y0_linewidth,'LineStyle','--');

xlabel('Mutation rate, $\mu$', 'Interpreter', 'latex', 'FontSize', label_font_size);  %
ylabel(' ${\it (b/c)^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

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
ytickformat('%d');    
ax = gca;
ax.YTick = unique(round(ax.YTick));
tickValues = ax.YTick;

newLabels = cell(size(tickValues));
for i = 1:length(tickValues)
    y_val = tickValues(i);
    if y_val == 0
        newLabels{i} = '0';
    elseif y_val > 0
        newLabels{i} = ['10^{' num2str(y_val) '}'];
    else
        newLabels{i} = ['-10^{' num2str(-y_val) '}'];
    end
end
ax.YTickLabel = newLabels;
ax.TickLabelInterpreter = 'tex';  

legend('Static','Dynamic');
legend('FontSize', 15);
legend('Box','off');
pbaspect([1 1 1]);




end
function M = Log_Mat(A)
[L1, L2] = size(A);
M = zeros(L1,L2);
for i = 1:L1 
    for j = 1:L2 
        if A(i,j) > 0
            M(i,j) = log10(A(i,j));
        else
            M(i,j) = -log10(-A(i,j));
        end
    end
end

end


%%% =================  Intelligent plot  ==================== %%%%%
function plot_with_breaks(x, y, varargin)
    sign_changes = find(diff(sign(y)) ~= 0);
    x_new = x;
    y_new = y;
    for i = length(sign_changes):-1:1
        pos = sign_changes(i) + 1;
        x_new = [x_new(1:pos-1), NaN, x_new(pos:end)];
        y_new = [y_new(1:pos-1), NaN, y_new(pos:end)];
    end
    plot(x_new, y_new, varargin{:});
end