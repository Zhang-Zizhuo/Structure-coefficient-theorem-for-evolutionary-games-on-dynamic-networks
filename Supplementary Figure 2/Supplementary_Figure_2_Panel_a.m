function Supplementary_Figure_2_Panel_a

filename = 'C:\Users\Lenovo\Desktop\Lambda_Six_Node_Chatgpt.txt';
BC = dlmread(filename);

ID = BC(1,:);       
perm_code = BC(2,:); 
Ls = BC(3:5,:);   
Ld = BC(9:11,:);

K1_static = Ls(1,:) - Ls(2,:);
K2_static = sum(Ls);
bc_static = K2_static ./ K1_static;       

K1_dynamic = Ld(1,:) - Ld(2,:);
K2_dynamic = sum(Ld);
bc_dynamic = K2_dynamic ./ K1_dynamic;   

bc_static_Log = Log_Mat(bc_static);
bc_dynamic_Log = Log_Mat(bc_dynamic);


[uniqueID, idx_unique] = unique(ID, 'stable');
unique_bcs = bc_static_Log(idx_unique);
[sorted_bcs, sort_idx] = sort(unique_bcs);
sorted_ID = uniqueID(sort_idx);

new_serial = (1:length(sorted_bcs))';

num_permutations = 719;  % 6!-1 = 720-1 = 719
bcd_by_network = cell(length(sorted_bcs), 1);

for i = 1:length(sorted_ID)
    network_id = sorted_ID(i);
    rows_for_network = find(ID == network_id);
    bcd_by_network{i} = bc_dynamic_Log(rows_for_network);
end

bar_handle = bar(new_serial, sorted_bcs, ...
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
    bcd_vals = bcd_by_network{i};
    num_vals = length(bcd_vals);
    if num_vals > 0
        x_vals = i + 0.3 * (rand(num_vals, 1) - 0.5); 
        scatter_x = [scatter_x; x_vals];
        scatter_y = [scatter_y; bcd_vals'];
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
ylabel('$(c/b)^*$', 'FontSize', 14, 'Interpreter','latex');

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
axis([0 112 -4.3 4.3]);
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