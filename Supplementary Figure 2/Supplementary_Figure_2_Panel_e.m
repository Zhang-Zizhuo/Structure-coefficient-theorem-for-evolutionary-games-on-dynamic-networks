function Supplementary_Figure_2_Panel_e

filename = 'Lambda_Six_Nodes.txt';
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

cb_static = 1 ./ bc_static;
cb_dynamic = 1 ./ bc_dynamic;

figure;
scatter(cb_static, cb_dynamic, 10, [178, 24, 43] / 256, 'filled');

xticks(-0.2:0.2:0.4);
xtickformat('%.1f');
yticks(-0.2:0.2:0.4);
ytickformat('%.1f');

box on;
set(gcf, 'Color', 'white');
pbaspect([1 1 1]);

SZ = 19;
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

ax = axis;
hold on
plot([min(ax(1),ax(3)), max(ax(2),ax(4))], ...
     [min(ax(1),ax(3)), max(ax(2),ax(4))], 'k--', 'LineWidth', 1);
axis(ax);

ax = axis; hold on;
L = 10*max(abs(ax)) + 1;  
P1 = polyshape([ax(1) ax(2) ax(2) ax(1)], [ax(3) ax(3) ax(4) ax(4)]);
P2 = polyshape([-L -L  L], [-L  L  L]); 
h = plot(intersect(P1,P2));
h.FaceColor = [0.82 0.91 1.00];  
h.EdgeColor = 'none';
axis(ax);  
uistack(h,'bottom');

ylabel('$(c/b)^*$ for dynamic', 'FontSize', 20, 'Interpreter','latex');
xlabel('$(c/b)^*$ for static', 'FontSize', 20, 'Interpreter','latex');
title('Cooperation', 'FontSize', 16);
