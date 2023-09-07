function enhanced_lorenz_attractor()
    % Parameters
    sigma = 10;
    beta = 8/3;
    rho = 28;

    % Initial condition
    y0 = [1; 1; 1];

    % Time span
    tspan = [0, 50];

    % Solve the differential equations using ode45
    [t, y] = ode45(@(t, y) lorenz_system(t, y, sigma, beta, rho), tspan, y0);

    % Visualization
    figure('Color', 'k');
    ax = axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    hold on;

    % Color gradient based on time
    cmap = colormap(jet(length(t)));

    % Directory to save frames
    outputDir = 'lorenz_frames';
    mkdir(outputDir);

    % Plot the trajectory with a dynamic color gradient
    for i = 2:length(t)
        plot3(y(i-1:i,1), y(i-1:i,2), y(i-1:i,3), 'LineWidth', 2, 'Color', cmap(i,:));
        title('Enhanced Lorenz Attractor', 'Color', 'w');
        xlabel('X axis');
        ylabel('Y axis');
        zlabel('Z axis');
        grid on;
        axis tight;
        view([-23 15]);
        drawnow;

        % Save frame as image
        frameFilename = fullfile(outputDir, sprintf('frame_%04d.png', i));
        imwrite(getframe(gca).cdata, frameFilename);

        pause(0.01);  % Adjust for desired speed
    end

    function dy = lorenz_system(t, y, sigma, beta, rho)
        dy = zeros(3, 1);
        dy(1) = sigma * (y(2) - y(1));
        dy(2) = y(1) * (rho - y(3)) - y(2);
        dy(3) = y(1) * y(2) - beta * y(3);
    end
end

