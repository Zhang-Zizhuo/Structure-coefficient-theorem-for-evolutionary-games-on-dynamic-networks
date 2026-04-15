function Figure_3_Panel_j

filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_k (t=0.1).txt';
L = dlmread(filename);

k = 2:1:80;

dense_sample = 2:2:79;
k = k(dense_sample);
L = L(:, dense_sample);


Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of the indicators \bar{p} with respect to \delta
dPs_Ulti = ( Lambda_static(1,:) - Lambda_static(2,:) ) / 12;
dPd_Ulti = ( Lambda_dynamic(1,:) - Lambda_dynamic(2,:) ) / 12;

delta = 0.0025;   %% Selection intensity


%%  Calculate $\bar{p} 
Ps_Ulti = 0.5 + delta * dPs_Ulti;
Pd_Ulti = 0.5 + delta * dPd_Ulti;


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;
Marker_Size = 18;

figure;
plot(k, Pd_Ulti, '.', 'Color', blue, 'MarkerSize', Marker_Size);
hold on;
plot(k, Ps_Ulti, '.', 'Color', red, 'MarkerSize', Marker_Size);

yticks([0.5 0.501]);
ytickformat('%.3f');


set(gca, 'FontSize', tick_font_size);


xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % x 轴标签
ylabel('Fainess, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size);  % y 轴标签

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);
xtickangle(0);

