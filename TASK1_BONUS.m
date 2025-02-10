% MATLAB Simulation for Space-Grade Pressure and Temperature Sensor 
% (With Altitude & Periodic Disturbances)

% Constants
P0 = 101.325;  % Sea-level pressure in kPa
T0 = 288.15;   % Sea-level temperature in Kelvin
L = 0.0065;    % Temperature lapse rate in K/m
H = 8500;      % Scale height for pressure (in meters)
h_max = 40000; % Maximum height (in meters) for space simulation (40 km)

% Generate Altitude Data
heights = 0:1000:h_max;  % Altitudes from 0 to 40,000 meters (every 1 km)

% Calculate Pressure and Temperature as a function of Height
pressure_values = P0 * exp(-heights / H);  % Exponential decay for pressure
temperature_values = T0 - L * heights;    % Linear temperature decrease

% Simulate Sensor Output 
pressure_output = pressure_values + randn(size(pressure_values)) * 0.2; % Increased noise
temperature_output = temperature_values - 273.15 + randn(size(temperature_values)) * 0.5; % Increased noise

% Add Sinusoidal Disturbances to Simulate Vibrations 
freq = 0.0001; % Lower frequency (0.0001 cycles/m = 0.1 cycles/km)
amplitude_pressure = 2.0; % Increased amplitude of pressure oscillations
amplitude_temperature = 6; % Increased amplitude of temperature oscillations

pressure_output = pressure_output + amplitude_pressure * sin(2 * pi * freq * heights);
temperature_output = temperature_output + amplitude_temperature * sin(2 * pi * freq * heights);

% Plotting the Results
figure;

% Plot 1: Pressure vs. Altitude
subplot(3,1,1);
plot(heights, pressure_output, 'b');
xlabel('Altitude (m)');
ylabel('Pressure (kPa)');
title('Pressure Sensor Simulation with Increased Disturbances');
grid on;
legend('Pressure with increased sinusoidal variations');

% Plot 2: Temperature vs. Altitude
subplot(3,1,2);
plot(heights, temperature_output, 'r');
xlabel('Altitude (m)');
ylabel('Temperature (°C)');
title('Temperature Sensor Simulation with Increased Disturbances');
grid on;
legend('Temperature with increased sinusoidal variations');

% Calculated Altitude vs. True Altitude
calculated_heights = H * log(P0 ./ pressure_output);

% Ensure third plot is displayed correctly
figure;
subplot(3,1,3);
plot(heights, calculated_heights, 'g', 'LineWidth', 1.5);
hold on;
plot(heights, heights, 'k--', 'LineWidth', 1.5); % y = x reference line
hold off;
xlabel('True Altitude (m)');
ylabel('Calculated Altitude (m)');
title('Calculated Altitude vs. True Altitude');
grid on;
legend('Calculated Altitude', 'Ideal y = x Line');

% Apply a Low-Pass Filter to Remove Sinusoidal Noise
fs = 1; % Sampling frequency (1 sample per km altitude step)
fc = 0.05; % Cutoff frequency in cycles/sample (0.05 cycles/km)
Wn = fc / (fs/2); % Correctly normalized cutoff frequency
[b, a] = butter(4, Wn, 'low'); % 4th order Butterworth filter
filtered_pressure = filtfilt(b, a, pressure_output);
filtered_temperature = filtfilt(b, a, temperature_output);

% Plot 4: Filtered vs. Unfiltered Data
figure;
subplot(2,1,1);
plot(heights, pressure_output, 'b', heights, filtered_pressure, 'g', 'LineWidth', 1.5);
xlabel('Altitude (m)');
ylabel('Pressure (kPa)');
title('Filtered vs. Unfiltered Pressure Data (Increased Noise)');
grid on;
legend('Noisy Pressure', 'Filtered Pressure');

subplot(2,1,2);
plot(heights, temperature_output, 'r', heights, filtered_temperature, 'g', 'LineWidth', 1.5);
xlabel('Altitude (m)');
ylabel('Temperature (°C)');
title('Filtered vs. Unfiltered Temperature Data (Increased Noise)');
grid on;
legend('Noisy Temperature', 'Filtered Temperature');

% Analysis of Sensor Behavior in Extreme Conditions
extreme_heights = [0, 5000, 10000, 20000, 30000, 40000]; % Altitudes from 0 to 40 km
fprintf('Sensor Output under Extreme Altitude Conditions:\n');
for h = extreme_heights
    pressure_reading = P0 * exp(-h / H) + randn() * 0.2; % Increased noise
    temperature_reading = T0 - L * h - 273.15 + randn() * 0.5; % Convert Kelvin to Celsius, increased noise
    fprintf('Altitude: %.1f m -> Pressure: %.2f kPa, Temperature: %.2f °C\n', ...
        h, pressure_reading, temperature_reading);
end
