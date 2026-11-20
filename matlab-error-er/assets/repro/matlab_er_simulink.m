function model = matlab_er_simulink(variant)
%MATLAB_ER_SIMULINK Make a new unsaved model for a Gain dimension exercise.
%  matlab_er_simulink('broken')   Update Model reports a size mismatch.
%  matlab_er_simulink('fixed')    Run displays the values 2 and 4.

if nargin < 1
    variant = 'broken';
end
switch variant
    case 'broken'
        gain = '2*eye(3)';
    case 'fixed'
        gain = '2*eye(2)';
    otherwise
        error('matlab_er_simulink:Variant', 'Choose broken or fixed.');
end

[~, suffix] = fileparts(tempname);
suffix = regexprep(suffix, '[^a-zA-Z0-9_]', '_');
model = ['mer_' suffix];
model = model(1:min(length(model),namelengthmax));
if bdIsLoaded(model) || exist([model '.slx'],'file') || exist([model '.mdl'],'file')
    error('matlab_er_simulink:ModelName', 'A different demo model name is needed. Try again.');
end

load_system('simulink');
new_system(model);
try
    add_block('simulink/Sources/Constant',[model '/Vector'], ...
        'Value','[1;2]','Position',[30 50 75 80]);
    add_block('simulink/Math Operations/Gain',[model '/Matrix Gain'], ...
        'Gain',gain,'Multiplication','Matrix(K*u)','Position',[125 50 185 80]);
    add_block('simulink/Sinks/Display',[model '/Result'], ...
        'Position',[235 42 305 92]);
    add_line(model,'Vector/1','Matrix Gain/1');
    add_line(model,'Matrix Gain/1','Result/1');
    set_param(model,'StopTime','1');
    open_system(model);
catch fault
    close_system(model,0);
    rethrow(fault);
end
end
