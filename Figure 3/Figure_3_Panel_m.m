function Figure_3_Panel_m

filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_k (t=10).txt';
L = dlmread(filename);
k = 2:1:80;

dense_sample = 2:2:79;
k = k(dense_sample);
L = L(:, dense_sample);


Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of the indicators \bar{p} with respect to \delta
B = 1.5;
dPs_Trust = ( (B - 1)*2 * Lambda_static(1,:) - 2 * Lambda_static(2,:) + (B-2) * Lambda_static(3,:) ) / 24;
dPd_Trust = ( (B - 1)*2 * Lambda_dynamic(1,:) - 2 * Lambda_dynamic(2,:) + (B-2) * Lambda_dynamic(3,:) ) / 24;


delta = 0.0025;   %% Selection intensity


%%  Calculate $\bar{p} 
Ps_Trust = 0.5 + delta * dPs_Trust;
Pd_Trust = 0.5 + delta * dPd_Trust;


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;
Marker_Size = 18;



figure;
plot(k, Pd_Trust, '.', 'Color', blue, 'MarkerSize', Marker_Size);
hold on;
plot(k, Ps_Trust, '.', 'Color', red, 'MarkerSize', Marker_Size);

axis([0 80 0.47 0.50]);


set(gca, 'FontSize', tick_font_size);

xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size); 
ylabel('Trust, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
ytickformat('%.2f');

xtickangle(0);

