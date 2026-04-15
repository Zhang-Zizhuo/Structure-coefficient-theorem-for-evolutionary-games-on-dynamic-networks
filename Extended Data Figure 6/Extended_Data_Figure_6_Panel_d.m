function Extended_Data_Figure_6_Panel_d

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


dPs_Ulti = ( Ls(1,:) - Ls(2,:) ) / 12;
dPd_Ulti = ( Ld(1,:) - Ld(2,:) ) / 12;
dPr_Ulti = ( Lr(1,:) - Lr(2,:) ) / 12;


delta = 0.0025;
Ps_Ulti = 0.5 + delta * dPs_Ulti;
Pd_Ulti = 0.5 + delta * dPd_Ulti;
Pr_Ulti = 0.5 + delta * dPr_Ulti;

figure;

plot(k, Pd_Ulti, '.', 'Color', blue, 'MarkerSize', 12);
hold on;
plot(k, Ps_Ulti, '.', 'Color', red, 'MarkerSize', 12);
hold on;
plot(k, Pr_Ulti, 'k.', 'MarkerSize', 12);

tick_font_size=18;

set(gca, 'FontSize', tick_font_size);

label_font_size=21;
xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % x 轴标签
ylabel('Fairness, ${\bar{p}}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % y 轴标签

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

ytickformat('%.3f');

axis([0 80 0.4975 0.502]);
pbaspect([1 1 1]);
