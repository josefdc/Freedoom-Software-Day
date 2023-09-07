function double_pendulum_simulation()

    % Condiciones iniciales [theta1, omega1, theta2, omega2]
    y0 = [pi/2, 0.5, pi, 0.5];

    % Parámetros del péndulo: [m1, m2, l1, l2, g]
    p = [1, 1, 1, 1, 9.81];

    % Tiempo de simulación
    tspan = linspace(0, 20, 1000);

    % Resolver usando lsode
    y = lsode(@(y, t) pendulumODE(y, t, p), y0, tspan);

    % Anima el péndulo doble
    animate_pendulum(tspan, y, p)

end

function dy = pendulumODE(y, t, p)

    m1 = p(1); m2 = p(2); l1 = p(3); l2 = p(4); g = p(5);

    delta = y(3) - y(1);
    omega1_squared = y(2)^2;
    omega2_squared = y(4)^2;

    den1 = (m1+m2) * l1 - m2 * l1 * cos(delta)^2;
    den2 = (l2/l1) * den1;

    % Check for small denominator values to avoid division by near-zero
    if abs(den1) < 1e-6
        den1 = 1e-6;
    end
    if abs(den2) < 1e-6
        den2 = 1e-6;
    end

    dy = zeros(4,1);
    dy(1) = y(2);
    dy(2) = ((m2*l2*omega2_squared*sin(delta)*cos(delta) ...
        + m2*g*sin(y(3))*cos(delta) ...
        + m2*l2*omega2_squared*sin(delta) ...
        - (m1+m2)*g*sin(y(1))) ...
        / den1 );
    dy(3) = y(4);
    dy(4) = ((- l1/l2)*omega1_squared*sin(delta)*cos(delta) ...
        + (m1+m2)*g*sin(y(1))*cos(delta) ...
        - (m1+m2)*l1*omega1_squared*sin(delta) ...
        - (m1+m2)*g*sin(y(3))) ...
        / den2;

end

function animate_pendulum(t, y, p)

    l1 = p(3); l2 = p(4);

    % Initialize the figure and plots
    figure(1);
    ground = plot([-2*l1, 2*l1], [0, 0], 'r'); % Suelo
    hold on;
    pendulum1 = line([0, l1*sin(y(1,1))], [0, -l1*cos(y(1,1))], 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
    pendulum2 = line([l1*sin(y(1,1)), l1*sin(y(1,1)) + l2*sin(y(1,3))], [-l1*cos(y(1,1)), -l1*cos(y(1,1)) - l2*cos(y(1,3))], 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);

    % Initialize arrays to store pendulum positions for tracing
    trace1_x = [];
    trace1_y = [];
    trace2_x = [];
    trace2_y = [];

    axis equal;
    axis([-2*l1, 2*l1, -2*l1, 2*l1]);
    grid on;

    dt = t(2) - t(1);  % Compute the time step

    for k = 1:length(t)
        % Update pendulum positions using set function
        set(pendulum1, 'XData', [0, l1*sin(y(k,1))], 'YData', [0, -l1*cos(y(k,1))]);
        set(pendulum2, 'XData', [l1*sin(y(k,1)), l1*sin(y(k,1)) + l2*sin(y(k,3))], 'YData', [-l1*cos(y(k,1)), -l1*cos(y(k,1)) - l2*cos(y(k,3))]);

        % Append current positions for tracing
        trace1_x = [trace1_x, l1*sin(y(k,1))];
        trace1_y = [trace1_y, -l1*cos(y(k,1))];
        trace2_x = [trace2_x, l1*sin(y(k,1)) + l2*sin(y(k,3))];
        trace2_y = [trace2_y, -l1*cos(y(k,1)) - l2*cos(y(k,3))];

        % Plot the traces
        plot(trace1_x, trace1_y, 'g-');
        plot(trace2_x, trace2_y, 'b-');

        title(sprintf('Tiempo: %.2f s', t(k)));

        pause(dt);  % Adjust the pause duration to match the ODE solution resolution
    end
    hold off;
end

