function Extended_Data_Figure_6_Panel_b

blue = [0, 92, 171] / 256;
red = [213, 94, 0]/256;
filename="C:\Users\Lenovo\Desktop\Compare_Hub_Chain_with_Rich_Club.txt";
matrix = dlmread(filename);

w=matrix;
k = 1:2:79;

Ls = w(1:3, :);
Lr = w(4:6, :);
% Ld = w(7:9, :);   %%  Rescaled duration t = 0.1
Ld = w(10:12, :);    %%  Rescaled duration t = 10

L = Ls;
K1 = L(1,:) - L(2,:);
K2 = L(1,:) + L(2,:) + L(3,:);
bcs = K2 ./ K1;

L = Ld;
K1 = L(1,:) - L(2,:);
K2 = L(1,:) + L(2,:) + L(3,:);
bcd = K2 ./ K1;

L = Lr;
K1 = L(1,:) - L(2,:);
K2 = L(1,:) + L(2,:) + L(3,:);
bcr = K2 ./ K1;


bcs = Log_Mat(bcs);
bcd = Log_Mat(bcd);
bcr = Log_Mat(bcr);


plot(k, bcr, 'k.', 'MarkerSize', 12);     
hold on;
plot(k, bcs, '.', 'Color', red, 'MarkerSize', 12);      
hold on;
plot(k, bcd, '.', 'Color', blue, 'MarkerSize', 12);

tick_font_size=18;
set(gca, 'FontSize', tick_font_size);

label_font_size=21;
xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size); 
ylabel('${\it (b/c)^*}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  


set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  
pbaspect([1 1 1]);

y0_color = [0.5 0.5 0.5]; 
y0_linewidth = 0.8;
yline(0, 'Color', y0_color, 'LineWidth', y0_linewidth,'LineStyle','--');


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