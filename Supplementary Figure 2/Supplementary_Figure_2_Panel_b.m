function Supplementary_Figure_2_Panel_b

filename = 'C:\Users\Lenovo\Desktop\Lambda_Six_Node_Chatgpt.txt';
BC = dlmread(filename);

ID = BC(1,:);     
perm_code = BC(2,:);
Lambda_static = BC(3:5,:);        
Lambda_dynamic = BC(9:11,:);     

dP_static = ( -2 * Lambda_static(2,:) - Lambda_static(3,:) ) / 12;   
dP_dynamic = ( -2 * Lambda_dynamic(2,:) - Lambda_dynamic(3,:) ) / 12;  

delta = 0.005;   %  Selection intensity

P_dynamic = 0.5 + delta * dP_dynamic;
P_static = 0.5 + delta * dP_static;

[uniqueID, idx_unique] = unique(ID, 'stable');
unique_Ps = P_static(idx_unique);
[sorted_Ps, sort_idx] = sort(unique_Ps);
sorted_ID = uniqueID(sort_idx);

new_serial = (1:length(sorted_Ps))';

num_permutations = 719;  % 6!-1 = 720-1 = 719
Pd_by_network = cell(length(sorted_Ps), 1);

for i = 1:length(sorted_ID)
    network_id = sorted_ID(i);
    rows_for_network = find(ID == network_id);
    Pd_by_network{i} = P_dynamic(rows_for_network);
end


bar_handle = bar(new_serial, sorted_Ps, ...
    'FaceColor', [250, 103, 122]/256, ...
    'FaceAlpha', 0.75, ...
    'EdgeColor', [142, 142, 142]/256, ...
    'LineWidth', 0.8, ...
    'BarWidth', 1);


bar_handle.BaseValue = 0.5;

hold on; 
scatter_x = []; 
scatter_y = [];

for i = 1:length(new_serial)
    Pd_vals = Pd_by_network{i};
    num_vals = length(Pd_vals);
    if num_vals > 0
        x_vals = i + 0.3 * (rand(num_vals, 1) - 0.5); 
        scatter_x = [scatter_x; x_vals];
        scatter_y = [scatter_y; Pd_vals'];
    end
end


scatter_handle = scatter(scatter_x, scatter_y, ...
    4, ...
    [73, 112, 182]/255, ...
    'filled', ...
    'MarkerFaceAlpha', 0.7, ...
    'MarkerEdgeAlpha', 0.7);

SZ = 19;
xlabel('Graph', 'FontSize', 14);
ylabel('Altruism, $\bar{p}$', 'FontSize', 14, 'Interpreter','latex');

box on;
set(gcf, 'Color', 'white');
pbaspect([2 1 1]);

xax = gca().XAxis;
set(xax, 'FontSize', SZ);
yax = gca().YAxis;
set(yax, 'FontSize', SZ);

ax = gca;
originalPos = ax.Position;

leftShift   = 0.05;  
bottomShift = 0.05;  

newLeft   = originalPos(1) + leftShift;
newBottom = originalPos(2) + bottomShift;
newWidth  = originalPos(3) - leftShift;
newHeight = originalPos(4) - bottomShift;
ax.Position = [newLeft, newBottom, newWidth, newHeight];

ytickformat('%.3f');

