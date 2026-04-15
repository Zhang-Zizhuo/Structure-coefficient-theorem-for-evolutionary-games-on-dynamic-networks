function Extended_Data_Figure_6_Panel_e

blue = [0, 92, 171] / 256;
red = [213, 94, 0]/256;
filename="C:\Users\Lenovo\Desktop\Compare_Hub_Chain_with_Rich_Club.txt";
matrix = dlmread(filename);

w=matrix;
k = 1:2:79;

Ls = w(1:3, :);
Lr = w(4:6, :);
Ld = w(7:9, :);   %%  Rescaled duration t = 0.1
% Ld = w(10:12, :);    %%  Rescaled duration t = 10

B = 1.5;
dPs_Trust = ( (B - 1)*2 * Ls(1,:) - 2 * Ls(2,:) + (B-2) * Ls(3,:) ) / 24;
dPd_Trust = ( (B - 1)*2 * Ld(1,:) - 2 * Ld(2,:) + (B-2) * Ld(3,:) ) / 24;
dPr_Trust = ( (B - 1)*2 * Lr(1,:) - 2 * Lr(2,:) + (B-2) * Lr(3,:) ) / 24;

delta=0.0025;
Ps_Trust = 0.5 + delta * dPs_Trust;
Pd_Trust = 0.5 + delta * dPd_Trust;
Pr_Trust = 0.5 + delta * dPr_Trust;


figure;

plot(k, Pd_Trust, '.', 'Color', blue, 'MarkerSize', 12);
hold on;
plot(k, Ps_Trust, '.', 'Color', red, 'MarkerSize', 12);
hold on;
plot(k, Pr_Trust, 'k.', 'MarkerSize', 12);

tick_font_size=18;
set(gca, 'FontSize', tick_font_size);

label_font_size=21;
xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size);  
ylabel('Trust, ${\bar{p}}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  


set(gcf, 'Color', 'w');
set(gca, 'Color', 'w'); 

axis([0 80 0.437 0.50]);
ytickformat('%.2f');
pbaspect([1 1 1]);
