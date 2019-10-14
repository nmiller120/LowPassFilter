% ECE 436 Project 1
% Nick Miller
% 10/30/2017

% call the function ECE436_project1() from MATLAB's command window. If no
% array of numerator and denominator coeffecients is provided, the script
% defaults to using the hardcoded coefficients.

function ECE436_project1(Num, Den)

    % If no numerator and denominator coeffecients are passed, use
    % defaults. 
    if nargin < 2 
        % These coefficients represent a fifth order filter  and 
        % yield a 1 dB ripple and a minimum of 36 dB stopband attenuation.
        
        % numerator coefficients
        Num = [0.2500    1.1637    2.2473    2.2478    1.1645    0.2503]; 
        
        % denominator coefficients
        Den = [1.0000    2.1832    2.3219    1.2951    0.3237         0];         
    end
    
    
    % numerator and denominator arrays need to be the same length, if they 
    % are not, zeros are appended on the end of either the numerator or
    % denominator. This doesn't change the structure of the transfer function.
    if length(Num) ~= length(Den)
        dif = length(Num)-length(Den);
        if dif > 0
            for x = 1:dif
                Den = [Den , 0];
            end
        end
        
        if dif < 0
            for x = 1:dif*(-1)
                Num = [Num, 0];
            end  
        end
    end
        
    % display the pole/zero and frequency response plots to the user
    filter_characteristics(Num, Den); 

    % read audio file and get two values
    % x - an time series array of values representing the voltage output for 
    % the DAC at a given sample time.
    % fs - the sampling frequency of the audio 
    [x,fs] = audioread('ece436_P1_Fall2017.wav'); 
    
    % pass the time series data through the filter with the numerator and 
    % denominator coefficients to the function myFilter() which implements
    % the low pass filter. y is returned which is time series data
    % representing the audio wave. Y has been passed through the low pass 
    % filter.
    y = myFilter(Num, Den, x); 

    % Function plots the frequency spectrum of the unfiltered signal
    plotfft(fs, x, 'Unfiltered Signal'); 
    
    % Function plots the frequency spectrum of the filtered signal
    plotfft(fs, y, 'Filtered Signal');  
    
    % play the unfiltered audio
    play_audio(x,fs);  
    
    % play the filtered audio
    play_audio(y,fs); 
    
    % write the data to an output file
    % audiowrite('outputFile.wav', y, fs)
    
end

function filter_characteristics(Num, Den)
    % Function takes the numerator and denomenator cefficients and plots
    % figures showing the DSP characteristics of the filter.
    
    % These functions are part of a package for MATLAB that aren't part
    % of the default libraries for matlab and cost extra to download. The
    % try catch clause will allow the script to run without them.
    try 
        
        % calculates the corresponding zeros and poles of the transfer
        % function
        [z,p,k] = tf2zp(Num,Den); 
        
        % create a new figure and plot the  poles and zeros of the transfer
        % function on the z-plane
        figure;
        zplane(z,p);  

        % create a new figure and plot the frequency response of the
        % transfer function
        figure;
        freqz(Num,Den);
        title('Frequency response');
    
    % close the figures if we don't have the libraries installed
    catch 
        disp('Error Occured');
        close;
    end
end


function play_audio(x,fs)
    % takes an audio signal and sampling frequency and plays it, while
    % adding a delay to allow time for the next signal to be played.
    
    % duration of delay (length of the audio in seconds + 1/2 second)
    delay = length(x)/fs + 0.5; 
    
    % play time series array
    sound(x,fs);  
    
    % delay for next signal (instruction is executed imediately following
    % sound())
    pause(delay); 
end


function plotfft(Fs, x, name)  
    % Function takes a signal, sampling frequency, and a figure title as
    % arguments. The function plots the fast fourier transform of the signal. 
    
    % Length of signal
    L = length(x); 
    
    % fourier transform of signal, Y is the frequency domain representation
    % of the signal
    Y = fft(x); 
    
    % The fast fourier transform returns an array of complex numbers. 
    % The magnitude of the number corresponds to the magnitude of the
    % corresponding frequency bin and the phase of the number is the phase
    % for the corresponding bin. This array is also contains redundant data 
    % that represents aliased frequences that have been mirrored about the 
    % nyquist frequency of the sampled signal. The code below truncates the
    % aliased frequency data,  calculates the magnitude data for the frequency
    % response, and calculates the values of the frequency bins in Hz.
    
    % return approprately scaled magnitude data (1 = 1 volt)
    P2 = abs(Y/L);
    
    % P1 is all frequency data below the nyquist frequency
    P1 = P2(1:floor(L/2+1));
    
    % I don't recall why this is done. 
    P1(2:end-1) = 2*P1(2:end-1);
    
    % calculating placement of frequency bins
    f = Fs*(0:floor((L/2)))/L;
    
    % plots the signal, adds title and labels
    figure;
    plot(f,P1);
    title(name);
    xlabel('f (Hz)');
    ylabel('|X(f)|');
end

function y = myFilter(b,a,x)
    % This function takes the numerator and denomenator coefficients as
    % well as the unfiltered signal as arguments. Returns a filtered
    % signal. This is my implementation of matlab's filter() function.
    
    % transpose of x, for ease of calculations
    x = x.'; 
    
    % N is the order of filter
    N = length(a)-1; 
    
    % add N unit delay to the unfiltered signal
    x = [zeros(1,N), x]; 
    
    % length of the unfiltered signal + the delay
    L = length(x); 
    
    % vector to become the filtered signal
    y = zeros(1,L); 
        
    
    % This code is to convert the transfer function to a difference 
    % equation and calculate y(n), effectively performing an inverse Z
    % transform
    for n = 1: L - N 
        sum_y_n = 0;
        for k = 1:N+1
            if k == 1
                sum_y_n = sum_y_n + x(n-k+N+1)*b(k);
            elseif k > 1
                sum_y_n = sum_y_n + x(n-k+N+1)*b(k) - y(n-k+N+1)*a(k);
            end
        end
        y(n+N) = sum_y_n;
    end
    
    % remove the delay and transpose y(n), return y
    y = y(N+1:end).';
end