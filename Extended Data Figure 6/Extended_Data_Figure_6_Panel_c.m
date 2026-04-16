function Extended_Data_Figure_6_Panel_c

blue = [0, 92, 171] / 256;
red = [213, 94, 0]/256;
filename="Compare_Core_Periphery_with_Rich_Club.txt";
matrix = dlmread(filename);

w=matrix;
k = 1:2:79;

Ls = w(1:3, :);
Lr = w(4:6, :);
Ld = w(7:9, :);   %%  Rescaled duration t = 0.1
% Ld = w(10:12, :);    %%  Rescaled duration t = 10

dPs_Dic = ( -2 * Ls(2,:) - Ls(3,:) ) / 12;
dPd_Dic = ( -2 * Ld(2,:) - Ld(3,:) ) / 12;
dPr_Dic = ( -2 * Lr(2,:) - Lr(3,:) ) / 12;

delta = 0.0025;
Ps_Dic = 0.5 + delta * dPs_Dic;
Pd_Dic = 0.5 + delta * dPd_Dic;
Pr_Dic = 0.5 + delta * dPr_Dic;


figure;

plot(k, Pd_Dic, '.', 'Color', blue, 'MarkerSize', 12);
hold on;
plot(k, Ps_Dic, '.', 'Color', red, 'MarkerSize', 12);
hold on;
plot(k, Pr_Dic, 'k.', 'MarkerSize', 12);

tick_font_size=18;

set(gca, 'FontSize', tick_font_size);

label_font_size=21;
xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Altruism, ${\bar{p}}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  


set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

axis([0 80 0.25 0.50]);
ytickformat('%.2f');
pbaspect([1 1 1]);
