function double_pendulum_simulation()

    % Condiciones iniciales [theta1, omega1, theta2, omega2]
    y0 = [pi/4, 0, pi/2, 0];

    % Parámetros del péndulo: [m1, m2, l1, l2, g]
    p = [1, 1, 1, 1, 9.81];

    % Tiempo de simulación
    tspan = [0, 20];

    % Resolver usando ode45
    [t,y] = ode45(@(t,y) pendulumODE(t,y,p), tspan, y0);

    % Anima el péndulo doble
    animate_pendulum(t, y, p)

end

function dy = pendulumODE(t, y, p)

    m1 = p(1); m2 = p(2); l1 = p(3); l2 = p(4); g = p(5);

    delta = y(3) - y(1);
    den1 = (m1+m2) * l1 - m2 * l1 * cos(delta) * cos(delta);
    den2 = (l2/l1) * den1;

    dy = zeros(4,1);
    dy(1) = y(2);
    dy(2) = ((m2*l2*y(4)*y(4)*sin(delta)*cos(delta)
        + m2*g*sin(y(3))*cos(delta) + m2*l2*y(4)*y(4)*sin(delta)
        - (m1+m2)*g*sin(y(1)))
        / den1 );
    dy(3) = y(4);
    dy(4) = ((- l1/l2)*y(2)*y(2)*sin(delta)*cos(delta)
        + (m1+m2)*g*sin(y(1))*cos(delta) - (m1+m2)*l1*y(2)*y(2)*sin(delta)
        - (m1+m2)*g*sin(y(3)))
        / den2 );

end

function animate_pendulum(t, y, p)

    l1 = p(3); l2 = p(4);

    for k = 1:length(t)
        % Primer péndulo
        x1 = l1*sin(y(k,1));
        y1 = -l1*cos(y(k,1));

        % Segundo péndulo
        x2 = x1 + l2*sin(y(k,3));
        y2 = y1 - l2*cos(y(k,3));

        % Dibujar péndulo
        figure(1);
        plot([-2*l1, 2*l1], [0, 0], 'r'); % Suelo
        hold on;
        plot([0, x1], [0, y1], '-o', [x1, x2], [y1, y2], '-o', 'LineWidth', 2, 'MarkerSize', 10);
        axis equal;
        axis([-2*l1, 2*l1, -2*l1, 2*l1]);
        title(sprintf('Tiempo: %.2f s', t(k)));
        grid on;
        hold off;

        pause(0.05);
    end

end

