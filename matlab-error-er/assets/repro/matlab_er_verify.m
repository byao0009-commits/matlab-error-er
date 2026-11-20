function matlab_er_verify(scope)
%MATLAB_ER_VERIFY Check fixed lab examples using numerical invariants.
%  matlab_er_verify              Only base MATLAB is required.
%  matlab_er_verify('toolbox')   Also check Control System Toolbox.

if nargin < 1
    scope = 'base';
end
if ~any(strcmp(scope, {'base','toolbox'}))
    error('matlab_er_verify:Scope', 'Choose base or toolbox.');
end

linear = matlab_er_demo('linear');
assert(isequal(size(linear.solution),[2 1]), 'Wrong solution shape.');
assert(norm(linear.solution-[1;2],inf) < 1e-12 && linear.residual < 1e-12, ...
    'The linear system did not give [1;2] with a small residual.');

fit = matlab_er_demo('fit');
assert(isequal(fit.dataSize,[6 2]) && isequal(fit.firstRow,[0 2.1]), ...
    'The numeric CSV was not read as six rows and two columns.');
assert(fit.rmse < 0.2, 'Unexpected fit error. Check the normalization.');
folder = fileparts(mfilename('fullpath'));
headerFile = fullfile(folder,'fit_header.csv');
numericFile = fullfile(folder,'fit_numeric.csv');
dataWithHeader = dlmread(headerFile,',',1,0);
numericData = dlmread(numericFile,',');
assert(isequal(dataWithHeader,numericData), 'Header and numeric CSVs disagree.');
if exist('readtable','file') || exist('readtable','builtin')
    importedTable = readtable(headerFile);
    assert(isequal(size(importedTable),[6 2]), 'Unexpected table dimensions.');
    assert(isequal(importedTable{:,:},numericData), 'readtable changed CSV data.');
    disp('readtable CSV check passed.');
end
if exist('readmatrix','file') || exist('readmatrix','builtin')
    assert(isequal(readmatrix(numericFile),numericData), 'readmatrix changed CSV data.');
    disp('readmatrix CSV check passed.');
end

ode = matlab_er_demo('ode');
assert(abs(ode.lastTime-pi/2) < 1e-12 && ode.maxError < 1e-6, ...
    'ODE output does not agree with the harmonic oscillator.');

fftResult = matlab_er_demo('fft');
assert(all(abs(fftResult.frequencyHz-[64 16*1024/255]) < 1e-10), ...
    'Wrong peak bin for even or odd FFT length.');
assert(all(abs(fftResult.amplitude-0.75) < 1e-10), 'Wrong single-sided amplitude.');
assert(abs(fftResult.nyquistAmplitude-0.25) < 1e-10, ...
    'The Nyquist component must not be doubled.');

image = matlab_er_demo('image');
assert(isequal(image.mask,logical([0 0; 1 1])), 'Unexpected threshold mask.');

control = matlab_er_demo('control');
assert(control.atStart == 0 && abs(control.atEnd-1.995) < 1e-3, ...
    'Unexpected first-order step-response endpoints.');
assert(abs(control.atOneTimeConstant-2*(1-exp(-1))) < 1e-12, ...
    'Unexpected response at one time constant.');

if strcmp(scope,'toolbox')
    sys = tf(2,[3 1]);
    t = (0:0.1:18)';
    [y,tOut] = step(sys,t);
    assert(numel(y) == numel(t) && numel(tOut) == numel(t), ...
        'Toolbox output does not use the requested grid.');
    assert(norm(tOut(:)-t,inf) < 1e-10, 'Unexpected step time vector.');
    assert(norm(y(:)-2*(1-exp(-tOut(:)/3)),inf) < 1e-7, ...
        'Toolbox step response disagrees with the analytic response.');
    disp('Control System Toolbox check passed.');
end

disp('Six base lab checks passed.');
end
