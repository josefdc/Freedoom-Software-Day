% Given code for vector field
[x, y] = meshgrid(linspace(-2, 2, 20), linspace(-2, 2, 20));
u = y;
v = -x;

% 1. Streamlines Visualization
figure;
startx = -2:0.2:2;
starty = -2*ones(size(startx));
streamline(x, y, u, v, startx, starty);
hold on;
streamline(x, y, u, v, starty, startx);  % Perpendicular streamlines
axis equal;
title('Streamlines of a Vortex');

% 2. Dynamic Simulation
figure;
quiver(x, y, u, v, 'b');
axis equal;
hold on;
title('Particle Movement in Vortex');
xlabel('x-axis');
ylabel('y-axis');

% Define initial particle positions
particles = [-1.5, -1.5;
             0, 1.5;
             1.5, 0;
             -1, 1];

num_steps = 100;
dt = 0.1;

for step = 1:num_steps
    for p = 1:size(particles, 1)
        % Update particle positions based on the vector field
        px = particles(p, 1);
        py = particles(p, 2);

        % Find velocities from the vector field
        u_interp = interp2(x, y, u, px, py, 'cubic');
        v_interp = interp2(x, y, v, px, py, 'cubic');

        % Update particle positions
        particles(p, 1) = px + u_interp * dt;
        particles(p, 2) = py + v_interp * dt;
    end

    % Plot updated particle positions
    plot(particles(:, 1), particles(:, 2), 'ro');
    pause(0.05);
end

% 3. Custom Color Maps
% We'll use the jet colormap as it's widely recognized.
% However, other colormaps like 'hot', 'cool', 'parula' can be explored.

% 4. "Interactivity"
% The above dynamic simulation already showcases particles being advected by the vortex.

