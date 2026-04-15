function Extended_Data_Figure_5_Panel_a

filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_t_add.txt';
L = dlmread(filename);

t = -1:0.03:2.99;   % Exponent of t

Ls = L(1:3, :);   % Structure coefficients of static counterparts
L_add = L(4:6, :);  % Structure coefficients of aggregated static networks (weighted networks)
L_max = L(7:9, :);  % Structure coefficients of aggregated static networks (unweighted networks)
Ld = L(10:12, :);  % Structure coefficients of dynamic networks


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
green = [0, 158, 115] / 256;

%% Calculate (b/c)* for cooperation
K1 = Ls(1,:) - Ls(2,:);
K2 = sum(Ls);
bcs = K2 ./ K1;

K1 = Ld(1,:) - Ld(2,:);
K2 = sum(Ld);
bcd = K2 ./ K1;

K1 = L_add(1,:) - L_add(2,:);
K2 = sum(L_add);
bc_add = K2 ./ K1;

K1 = L_max(1,:) - L_max(2,:);
K2 = sum(L_max);
bc_max = K2 ./ K1;

bcs = Log_Mat(bcs);
bcd = Log_Mat(bcd);
bc_add = Log_Mat(bc_add);
bc_max = Log_Mat(bc_max);

figure;
plot_with_breaks(t, bcs, 'Color', red, 'LineWidth', 2.5);
hold on;
plot_with_breaks(t, bcd, 'Color', blue, 'LineWidth', 2.5);
hold on;
plot_with_breaks(t, bc_add, 'Color', green, 'LineWidth', 2.5);
hold on;
plot_with_breaks(t, bc_max, 'Color', green, 'LineStyle', '--', 'LineWidth', 2.5);

tick_font_size=17.5;
set(gca, 'FontSize', tick_font_size);

label_font_size=21;
xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size); 
ylabel('${\it (b/c)^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
axis([-1 3 -4 4]);
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

y0_color = [0.7 0.7 0.7]; 
y0_linewidth = 0.8;
yline(0, 'Color', y0_color, 'LineWidth', y0_linewidth,'LineStyle','--');

legend('Static', 'Dynamic', 'Aggregate 1', 'Aggregate 2');
legend('FontSize', 17);
legend('box', 'off');



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