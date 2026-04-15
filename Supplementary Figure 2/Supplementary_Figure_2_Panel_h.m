function Supplementary_Figure_2_Panel_h

filename = 'C:\Users\Lenovo\Desktop\Lambda_Six_Node_Chatgpt.txt';
BC = dlmread(filename);

Lambda_static = BC(3:5,:);      
Lambda_dynamic = BC(9:11,:); 

B = 1.5;
dP_static= ( (B - 1)*2 * Lambda_static(1,:) - 2 * Lambda_static(2,:) + (B-2) * Lambda_static(3,:) ) / 24; 
dP_dynamic = ( (B - 1)*2 * Lambda_dynamic(1,:) - 2 * Lambda_dynamic(2,:) + (B-2) * Lambda_dynamic(3,:) ) / 24; 

delta = 0.005;   %  Selection intensity

P_dynamic = 0.5 + delta * dP_dynamic;
P_static = 0.5 + delta * dP_static;

figure;
scatter(P_static, P_dynamic, 10, [178, 24, 43] / 256, 'filled');
axis([0.497 0.5 0.497 0.5]);
xticks(0.497:0.001:0.5);
yticks(0.497:0.001:0.5);

xtickformat('%.3f');
ytickformat('%.3f');

SZ = 19;

box on;
set(gcf, 'Color', 'white');
pbaspect([1 1 1]);

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

hold on;
L = 10*max(abs(ax)) + 1;   
P1 = polyshape([ax(1) ax(2) ax(2) ax(1)], [ax(3) ax(3) ax(4) ax(4)]); 
P2 = polyshape([-L -L  L], [-L  L  L]); 
h = plot(intersect(P1,P2));
h.FaceColor = [0.82 0.91 1.00];  
h.EdgeColor = 'none';
axis(ax);
uistack(h,'bottom')

ylabel('$\bar{p}$ for dynamic', 'FontSize', 20, 'Interpreter','latex');
xlabel('$\bar{p}$ for static', 'FontSize', 20, 'Interpreter','latex');
title('Trust', 'FontSize', 16);