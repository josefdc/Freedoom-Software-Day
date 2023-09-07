function heat_equation_2D()
    % Parameters
    Nx = 50;  % number of grid points in x
    Ny = 50;  % number of grid points in y
    Nt = 500; % number of time steps
    dt = 0.01;
    alpha = 0.25;  % diffusion coefficient

    dx = 2 / (Nx - 1);
    dy = 2 / (Ny - 1);

    % Initialize temperature field
    T = zeros(Ny, Nx);
    T(round(Ny/2), round(Nx/2)) = 100;  % initial condition: heat source in the center

    % Time-stepping loop
    figure;
    for n = 1:Nt
        % Laplacian using finite differences
        laplacian = del2(T, dx, dy);

        % Time integration (explicit Euler method)
        T = T + alpha * dt * laplacian;

        % Boundary conditions (keep edges at zero temperature)
        T(:, [1, end]) = 0;
        T([1, end], :) = 0;

        % Visualization
        imagesc(T);
        colorbar;
        caxis([0 100]);
        title(['Time step: ', num2str(n)]);
        pause(0.05);
    end
end

