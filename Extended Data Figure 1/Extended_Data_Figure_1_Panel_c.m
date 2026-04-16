function Extended_Data_Figure_1_Panel_c

blue = [0, 92, 171] / 256;
red = [200, 40, 40] / 256;
tick_font_size = 21;
Marker_Size = 18;


filepath_s_donation = "Data\simu_static_donation_delta=0.5.txt";
filepath_d_donation = "Data\simu_dynamic_donation_delta=0.5.txt";

M_s_donation = readmatrix(filepath_s_donation);
M_d_donation = readmatrix(filepath_d_donation);

x = M_s_donation(1,:);
ys = M_s_donation(2,:);
yd = M_d_donation(2,:);

figure;
plot(x, yd, 's', 'MarkerSize',Marker_Size, 'MarkerFaceColor', blue, 'MarkerEdgeColor', 'none');
hold on;
plot(x, ys, 's', 'MarkerSize',Marker_Size, 'MarkerFaceColor', red, 'MarkerEdgeColor', 'none');


set(gca,'FontSize',tick_font_size);

set(gcf,'Color','w');
set(gca,'Color','w');

axis([100 160 0.0253-0.00002 0.0257+0.00002]);
yticks([0.0253, 0.0255, 0.0257]);
box on;
pbaspect([1 1 1]);

title('$\delta=0.01$', 'FontSize', 21, 'Interpreter','latex');
xlabel('Core periphery, $N_p$', 'FontSize', 21, 'Interpreter','latex');
ylabel('Cooperation frequency, $f_C$', 'FontSize', 21, 'Interpreter','latex');