function Extended_Data_Figure_3_Panel_a


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;

filename = 'C:\Users\Lenovo\Desktop\结果TXT\CP_Average_Parameter_u (t=10).txt';
L = dlmread(filename);

u = -3:0.04:0;   % Exponent of u
Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%% Calculate (b/c)* for cooperation
K1 = Lambda_static(1,:) - Lambda_static(2,:);
K2 = sum(Lambda_static);
bc_static = K2 ./ K1;

K1 = Lambda_dynamic(1,:) - Lambda_dynamic(2,:);
K2 = sum(Lambda_dynamic);
bc_dynamic = K2 ./ K1;

bc_static = Log_Mat(bc_static);
bc_dynamic = Log_Mat(bc_dynamic);


tick_font_size=18;
label_font_size=21;


bc_static(end)=[];
bc_dynamic(end)=[];
u_cut_end = u;
u_cut_end(end) = [];
figure;
plot_with_breaks(u_cut_end, bc_static, 'Color', red, 'LineWidth', 2.5);
hold on;
plot_with_breaks(u_cut_end, bc_dynamic, 'Color', blue, 'LineWidth', 2.5);

axis([-3 0 -4.16 4.16]);

set(gca, 'FontSize', tick_font_size);

xlabel('Mutation rate, $\mu$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('${\it (b/c)^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);


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

ax = gca;
ax.YTick = unique(ax.YTick);


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

y0_color = [0.5 0.5 0.5];
y0_linewidth = 1.2; 
yline(0, 'Color', y0_color, 'LineWidth', y0_linewidth,'LineStyle','--');

x0_color = [0.5 0.5 0.5]; 
x0_linewidth = 0.01;
xline(-1.18, 'Color', x0_color, 'LineWidth', x0_linewidth,'LineStyle','--');

xtickangle(0);


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