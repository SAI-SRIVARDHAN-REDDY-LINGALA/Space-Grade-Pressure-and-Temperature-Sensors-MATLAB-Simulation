% MATLAB Simulation for Space-Grade Pressure and Temperature Sensor (With Altitude)

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

% Simulate Sensor Output (Adding Noise)
pressure_output = pressure_values + randn(size(pressure_values)) * 0.05; % Adding noise
temperature_output = temperature_values - 273.15 + randn(size(temperature_values)) * 0.1; % Convert Kelvin to Celsius and add noise

% Plotting the Results
figure;

% Plot a: Pressure vs. Altitude
subplot(3,1,1);
plot(heights, pressure_output, 'b');
xlabel('Altitude (m)');
ylabel('Pressure (kPa)');
title('Pressure Sensor Simulation vs. Altitude');
grid on;
legend('Pressure decreases exponetially  as height increases');


% Plot b: Temperature vs. Altitude
subplot(3,1,2);
plot(heights, temperature_output, 'r');
xlabel('Altitude (m)');
ylabel('Temperature (°C)');
title('Temperature Sensor Simulation vs. Altitude');
grid on;
legend('Temperature decreases linearly as height increases');


% Calculating True Altitude from Measured Pressure (Inverse Calculation)
calculated_heights = H * log(P0 ./ pressure_output); % Inverse of the pressure-altitude relationship

% Plot c: Calculated vs True Altitude (from Pressure Measurement)
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



% Analysis of Sensor Behavior
% Simulating extreme space-like conditions (low altitude)
extreme_heights = [0, 5000, 10000, 20000, 30000, 40000]; % Altitudes from 0 to 40 km

% Displaying sensor outputs under extreme conditions
fprintf('Sensor Output under Extreme Altitude Conditions:\n');
for h = extreme_heights
    pressure_reading = P0 * exp(-h / H) + randn() * 0.05;
    temperature_reading = T0 - L * h - 273.15 + randn() * 0.1; % Convert Kelvin to Celsius
    fprintf('Altitude: %.1f m -> Pressure: %.2f kPa, Temperature: %.2f °C\n', ...
        h, pressure_reading, temperature_reading);
end