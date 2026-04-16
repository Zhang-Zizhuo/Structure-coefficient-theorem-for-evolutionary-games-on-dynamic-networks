function Supplementary_Figure_3_Panel_c

red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;

filename = 'SF_Periphery_Lambda.txt';
L = dlmread(filename);

t = -1:0.04:3;  %% Exponent of t

tick_font_size=18;
label_font_size=21;


Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate (b/c)*
K1 = Lambda_static(1,:) - Lambda_static(2,:);
K2 = sum(Lambda_static);
bc_static = K2 ./ K1;

K1 = Lambda_dynamic(1,:) - Lambda_dynamic(2,:);
K2 = sum(Lambda_dynamic);
bc_dynamic = K2 ./ K1;

bc_static = Log_Mat(bc_static);
bc_dynamic = Log_Mat(bc_dynamic);

figure;
plot_with_breaks(t, bc_static, 'Color', red, 'LineWidth', 2.5);
hold on;
plot_with_breaks(t, bc_dynamic, 'Color', blue, 'LineWidth', 2.5);

axis([-1 3 1.75 2.01]);

set(gca, 'FontSize', tick_font_size);


xlabel('Rescaled duration, $t$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
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

yticks([1.8 1.9 2.0]);
ax.TickLabelInterpreter = 'tex';  
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