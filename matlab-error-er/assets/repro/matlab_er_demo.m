function out = matlab_er_demo(caseName, variant)
%MATLAB_ER_DEMO Run one original lab example in broken or fixed form.
%  result = matlab_er_demo('fft','fixed')
%  Cases: linear, fit, ode, fft, image, control.
%  Fixed examples use base MATLAB. Some broken examples raise an error.

if nargin < 2
    variant = 'fixed';
end
if ~any(strcmp(variant, {'broken','fixed'}))
    error('matlab_er_demo:Variant', 'Choose broken or fixed.');
end
broken = strcmp(variant, 'broken');

switch caseName
    case 'linear'
        A = [3 1; 1 2];
        b = [5 5];
        if broken
            x = A\b;
        else
            x = A\b(:);
        end
        out.solution = x;
        out.residual = norm(A*x-b(:), inf);

    case 'fit'
        folder = fileparts(mfilename('fullpath'));
        data = dlmread(fullfile(folder,'fit_numeric.csv'), ',');
        x = data(:,1);
        y = data(:,2);
        [p,S,mu] = polyfit(x,y,1);
        if broken
            fitted = polyval(p,x);
        else
            fitted = polyval(p,x,S,mu);
        end
        out.rmse = sqrt(mean((y-fitted).^2));
        out.dataSize = size(data);
        out.firstRow = data(1,:);

    case 'ode'
        rhs = @(t,y) [y(2); -y(1)];
        y0 = [1;0];
        opts = odeset('RelTol',1e-8,'AbsTol',1e-10);
        if broken
            callback = rhs(0,y0);
        else
            callback = rhs;
        end
        [t,Y] = ode45(callback,[0 pi/2],y0,opts);
        out.lastTime = t(end);
        out.lastState = Y(end,:);
        out.maxError = norm(Y(end,:)-[cos(t(end)) -sin(t(end))],inf);

    case 'fft'
        Fs = 1024;
        lengths = [256 255];
        out.frequencyHz = zeros(size(lengths));
        out.amplitude = zeros(size(lengths));
        out.nyquistAmplitude = NaN;
        for idx = 1:numel(lengths)
            N = lengths(idx);
            t = (0:N-1)/Fs;
            x = 0.75*sin(2*pi*(16*Fs/N)*t);
            if mod(N,2) == 0
                x = x + 0.25*(-1).^(0:N-1);
            end
            spectrum = fft(x);
            last = floor(N/2)+1;
            P = abs(spectrum(1:last))/N;
            if broken
                f = (1:last)*Fs/N;
            else
                f = (0:last-1)*Fs/N;
                if mod(N,2) == 0
                    P(2:end-1) = 2*P(2:end-1);
                else
                    P(2:end) = 2*P(2:end);
                end
            end
            [out.amplitude(idx), bin] = max(P);
            out.frequencyHz(idx) = f(bin);
            if mod(N,2) == 0
                out.nyquistAmplitude = P(end);
            end
        end

    case 'image'
        I = uint8([0 127;128 255]);
        if broken
            G = double(I);
        else
            G = double(I)/255;
        end
        out.mask = G > 0.5;

    case 'control'
        % Analytic unit-step response of G(s) = 2/(3*s+1).
        t = (0:0.1:18)';
        if broken
            tau = 1/3;
        else
            tau = 3;
        end
        y = 2*(1-exp(-t/tau));
        out.atStart = y(1);
        out.atOneTimeConstant = y(31);
        out.atEnd = y(end);

    otherwise
        error('matlab_er_demo:Case', ...
            'Choose linear, fit, ode, fft, image, or control.');
end
end
