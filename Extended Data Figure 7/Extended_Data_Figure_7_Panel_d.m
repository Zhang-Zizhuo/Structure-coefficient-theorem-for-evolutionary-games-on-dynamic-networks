function Extended_Data_Figure_7_Panel_d

filename="Optimal_t_vs_k.txt";
matrix = dlmread(filename);

Ks = matrix(1,:);

bcd = matrix(3,:);
bcs = matrix(4,:);
bcd_fix = matrix(5, :);

bcd = Log_Mat(bcd);
bcs = Log_Mat(bcs);
bcd_fix = Log_Mat(bcd_fix);


blue = [0, 92, 171] / 256;
red = [200, 40, 40] / 256;
green = [0, 140, 90] / 256;
tick_font_size=17;
label_font_size=19;


figure;
plot(Ks, bcd, '.', ...
     'Color', green, ...
     'MarkerSize', 14);
hold on;
plot_with_breaks(Ks, bcs, '.', 'Color', red, 'MarkerSize', 14);
hold on;
plot_with_breaks(Ks, bcd_fix, '.', 'Color', blue, 'MarkerSize', 14);

set(gca, 'FontSize', tick_font_size);

y0_color = [0.5 0.5 0.5];
y0_linewidth = 0.8;
yline(0, 'Color', y0_color, 'LineWidth', y0_linewidth,'LineStyle','--');

xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel(' ${\it (b/c)^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');

axis([0 100 1.6 5]);

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


%%% ================= Intelligent plot  ==================== %%%%%
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