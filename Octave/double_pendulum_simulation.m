% double_pendulum_simulation
% Esta función realiza una simulación del péndulo doble y anima su movimiento.
function double_pendulum_simulation()

    % Condiciones iniciales para los ángulos y velocidades angulares de las dos barras del péndulo
    y0 = [pi/2, 0.5, pi, 0.5];

    % Parámetros del péndulo: [masa1, masa2, longitud1, longitud2, gravedad]
    p = [1, 1, 1, 1, 9.81];

    % Definición del tiempo de simulación
    tspan = linspace(0, 20, 1000);

    % Solución del sistema de ecuaciones diferenciales del péndulo doble
    y = lsode(@(y, t) pendulumODE(y, t, p), y0, tspan);

    % Animación del movimiento del péndulo doble
    animate_pendulum(tspan, y, p)

end

% pendulumODE
% Esta función define las ecuaciones diferenciales que rigen el movimiento del péndulo doble.
function dy = pendulumODE(y, t, p)

    % Extracción de los parámetros del péndulo
    m1 = p(1); m2 = p(2); l1 = p(3); l2 = p(4); g = p(5);

    % Calcula la diferencia entre los dos ángulos
    delta = y(3) - y(1);
    omega1_squared = y(2)^2;
    omega2_squared = y(4)^2;

    % Cálculos intermedios para las ecuaciones diferenciales
    den1 = (m1+m2) * l1 - m2 * l1 * cos(delta)^2;
    den2 = (l2/l1) * den1;

    % Verifica si el denominador es muy pequeño y lo ajusta para evitar divisiones cerca de cero
    if abs(den1) < 1e-6
        den1 = 1e-6;
    end
    if abs(den2) < 1e-6
        den2 = 1e-6;
    end

    % Ecuaciones diferenciales del péndulo doble
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

% animate_pendulum
% Esta función crea una animación del péndulo doble usando la solución del sistema de ecuaciones diferenciales.
function animate_pendulum(t, y, p)

    % Extrae las longitudes de las barras del péndulo
    l1 = p(3); l2 = p(4);

    % Inicialización de la figura y trazados
    figure(1);
    ground = plot([-2*l1, 2*l1], [0, 0], 'r'); % Línea que representa el suelo
    hold on;
    % Representación de las barras del péndulo
    pendulum1 = line([0, l1*sin(y(1,1))], [0, -l1*cos(y(1,1))], 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
    pendulum2 = line([l1*sin(y(1,1)), l1*sin(y(1,1)) + l2*sin(y(1,3))], [-l1*cos(y(1,1)), -l1*cos(y(1,1)) - l2*cos(y(1,3))], 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);

    % Arrays para almacenar las posiciones de las barras para realizar trazados
    trace1_x = [];
    trace1_y = [];
    trace2_x = [];
    trace2_y = [];

    axis equal;
    axis([-2*l1, 2*l1, -2*l1, 2*l1]);
    grid on;

    dt = t(2) - t(1);  % Cálculo del paso de tiempo

    % Animación de las barras del péndulo en cada paso de tiempo
    for k = 1:length(t)
        % Actualiza las posiciones de las barras del péndulo
        set(pendulum1, 'XData', [0, l1*sin(y(k,1))], 'YData', [0, -l1*cos(y(k,1))]);
        set(pendulum2, 'XData', [l1*sin(y(k,1)), l1*sin(y(k,1)) + l2*sin(y(k,3))], 'YData', [-l1*cos(y(k,1)), -l1*cos(y(k,1)) - l2*cos(y(k,3))]);

        % Agrega las posiciones actuales para realizar trazados
        trace1_x = [trace1_x, l1*sin(y(k,1))];
        trace1_y = [trace1_y, -l1*cos(y(k,1))];
        trace2_x = [trace2_x, l1*sin(y(k,1)) + l2*sin(y(k,3))];
        trace2_y = [trace2_y, -l1*cos(y(k,1)) - l2*cos(y(k,3))];

        % Dibuja las trazas de las barras
        plot(trace1_x, trace1_y, 'g-');
        plot(trace2_x, trace2_y, 'b-');

        title(sprintf('Tiempo: %.2f s', t(k)));  % Actualiza el título con el tiempo actual

        pause(dt);  % Pausa para que la animación coincida con la resolución de la solución ODE
    end
    hold off;
end
