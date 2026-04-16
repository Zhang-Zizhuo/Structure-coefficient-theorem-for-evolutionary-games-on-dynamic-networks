function Figure_3_Panel_d

filename = 'Core_Periphery_Lambda_vs_k_t=10.txt';
L = dlmread(filename);
k = 2:1:80;  % Index

dense_sample = 2:2:79;
k = k(dense_sample);
L = L(:, dense_sample);


Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;
Marker_Size = 18;




K1 = Lambda_static(1,:) - Lambda_static(2,:);
K2 = sum(Lambda_static);
bc_static = K2 ./ K1;

K1 = Lambda_dynamic(1,:) - Lambda_dynamic(2,:);
K2 = sum(Lambda_dynamic);
bc_dynamic = K2 ./ K1;

bc_static = Log_Mat(bc_static);
bc_dynamic = Log_Mat(bc_dynamic);

figure;
plot(k, bc_dynamic, '.', 'Color', blue, 'MarkerSize', Marker_Size);
hold on;
plot(k, bc_static, '.', 'Color', red, 'MarkerSize', Marker_Size);


set(gca, 'FontSize', tick_font_size);

xlabel('Periphery size, $k$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % x 轴标签
ylabel('${\it (b/c)^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % y 轴标签

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);


axis([0 80 1 4]);

ytickformat('%d'); 
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
