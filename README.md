# LowPassFilter
This MATLAB script implements a low pass filter using a digital filter designed using Matlab's filter designer utility. The lowpass filter is designed to remove a high frequency whine from a corrupted audio file. This project was completed as part of ECE 463 at Purdue University Fort Wayne. A link to a video demo of the project can be seen via the following link: https://www.youtube.com/watch?v=6KmEPY9GCFM

## Filter Design

The filter was designed based on the concepts of linear time-invariant system theory. LTI system theory provides a framework to describe mathematically the response of physical systems to an arbitrary input function. In this project our input function is the corrupted audio file, the LTI system is the low pass filter that we design, and the output is a new audio file with the high pitched whine removed.  

The LTI system can be modeled as a transfer function. The transfer function represents the frequency response of an LTI system and is derived from a mathematical operation called a Z-transform. To design a filter we must build a transfer function in such a way that low frequencies see no effect to the filter and higher frequencies are attenuated. 

Transfer functions generally appear as a rational equation with the numerator and denominator being polynomials. In designing the filter we used a graphic utility provided by MATLAB to manipulate placement of the poles and zeros of the transfer function. The utility also displays a window showing the resulting frequency response. Using this utility I decided on the following placement of poles and zeros. X's denote the placement of poles, and O's denote the placement of zeros. These values are plotted on the complex plane where the x-axis represents the number's real component and the y-axis represents the number's imaginary component. The poles are values which make the denominator of the transfer function zero and the zeros ore numbers which make the numerator of the transfer function zero. The phase of the complex zero or pole represent where in the frequency spectrum the effect takes place. Zeros attenuate frequencies near their phase placement and poles amplify frequncies near their phase placement. The closer the poles and zeros are to having a magnitude of 1, the more dramatic the effect of their placement.

For this filter most of the zeros were placed near the nyquist frequency to create a steep rolloff and poles were placed in such a way so  as to balance out the passband of the filter. Since the whine started at around 8 kHz, 7.5kHz was decided on as the cutoff frequency. 

![Pole Zero Plot](https://imgur.com/ZKxkQcA)

This pole zero placement yields the following frequency response...

![Frequency Response Plot](https://imgur.com/phpvtot)

And transfer function...

![Transfer Function](https://imgur.com/x2n1TvU)

The coefficients of the transfer function above were then passed to the MATLAB script in this repository. The MATLAB script takes the time series data from the given file, passes it through the low pass filter described above, then outputs the audio file without the high frequency whine. The script also provides plots of the features of the filter and the frequency spectrums of the input and output file. 

Thanks for reading!
