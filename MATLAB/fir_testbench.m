% Load the input signal array from the text file
input_signal = load('input_signal.txt');

% Define the coefficients for the filter
filter_coefficients = load('filter_coefficients.txt');

% Call our fir function using the inputs to get output array
output_signal = fir(input_signal, filter_coefficients);

% Write output signal array to a text file, one value per line
output_file = fopen('output_signal.txt', 'w');
fprintf(output_file, '%.6f\n', output_signal);
fclose(output_file);
