function Supplementary_Figure_1_Panel_b

filename = 'C:\Users\Lenovo\Desktop\CP_coop_d.txt';

L = dlmread(filename);
b = L(1,:);
fc = L(2,:);

K1 = 0.1884642007413863;
K2 = 0.9759620428432418;

delta = 0.001;
Th = delta*(K1*b - K2) + 0.5;
figure;

blue = [0, 92, 171] / 256;
plot(b, Th, 'Color', blue, 'LineWidth',2);
hold on;
plot(b, fc, 's', 'MarkerSize',13, 'MarkerFaceColor', blue, 'MarkerEdgeColor', 'none');

y0_color = [0.5 0.5 0.5]; 
y0_linewidth = 0.8; 
yline(0.5, 'Color', y0_color, 'LineWidth', y0_linewidth,'LineStyle','--');

x0_color = [0.5 0.5 0.5];
x0_linewidth = 1.4; 
xline(K2/K1, 'Color', x0_color, 'LineWidth', x0_linewidth,'LineStyle','--');

tick_font_size=17.5;
set(gca, 'FontSize', tick_font_size);

label_font_size=21;
xlabel('Benefit, $b$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Cooperation frequency, ${\it f_c}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
ytickformat('%.4f');

