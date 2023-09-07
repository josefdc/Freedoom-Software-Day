function mandelbrot_set()
    % Parameters
    N = 1000;  % resolution
    max_iter = 100;
    bounds = [-2, 2, -2, 2];  % [xmin xmax ymin ymax]

    % Generate a 2D grid of complex numbers
    [x, y] = meshgrid(linspace(bounds(1), bounds(2), N), linspace(bounds(3), bounds(4), N));
    z = x + 1i*y;
    c = z;

    % Mandelbrot iteration
    for n = 1:max_iter
        z = z.^2 + c;
    end

    % Convert to binary image for visualization
    bw = abs(z) < 8;

    % Display
    figure;
    imagesc(bw);
    colormap([0, 0, 0; 1, 1, 1]);
    axis off;
    title('Mandelbrot Set');
end

