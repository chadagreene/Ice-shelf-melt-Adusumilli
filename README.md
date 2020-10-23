# Description 
This function loads (and calculates when necessary) melt rates from [Adusumilli et al's 2020 dataset](https://library.ucsd.edu/dc/object/bb0448974g). 

The easiest way to see how to work with this function is to make sure Matlab can find all the contents of these folders and then type 

    showdemo melt_data_adusumilli_documentation

into the Matlab command window. Or just find the `melt_data_adusumilli_documentation.html` file and open it in a web browser. 

# Requirements 
If you just want a function to load the 500 m resolution composite melt rate map, all you need is the dataset listed in the first link below. However, if you want _time series_ of melt rates, you'll also need to get some ice thickness and velocity data, and the supporting Matlab tools I've written. That's because the time series data contains only surface elevations, and this function does the dirty work of (crudely) accounting for ice divergence to convert those surface elevations into basal melt rates. 

- Both melt datasets found under the **Components** link [here](https://library.ucsd.edu/dc/object/bb0448974g).
- Antarctic Mapping Tools for Matlab found [here](https://www.mathworks.com/matlabcentral/fileexchange/47638).
- BedMachine data found [here](https://nsidc.org/data/nsidc-0756). 
- BedMachine functions found [here](https://www.mathworks.com/matlabcentral/fileexchange/69159). 
- ITS_LIVE functions found [here](https://github.com/chadagreene/ITS_LIVE). 
- ITS_LIVE velocity mosaic data found [here](https://its-live.jpl.nasa.gov/). 
- Climate Data Toolbox for Matlab found [here](https://github.com/chadagreene/CDT). 



# Citation 
Please cite Susheel's dataset and/or paper! It's probably also scientifically prudent to cite Antarctic Mapping Tools because the conversion from surface elevation to melt rate is performed by this function. 

Adusumilli, Susheel; Fricker, Helen A.; Medley, Brooke C.; Padman, Laurie; Siegfried, Matthew R. (2020). Data from: Interannual variations in meltwater input to the Southern Ocean from Antarctic ice shelves. UC San Diego Library Digital Collections. Adusumilli, Susheel; Fricker, Helen A.; Medley, Brooke C.; Padman, Laurie; Siegfried, Matthew R. (2020). Data from: Interannual variations in meltwater input to the Southern Ocean from Antarctic ice shelves. UC San Diego Library Digital Collections. [https://doi.org/10.6075/J04Q7SHT](https://doi.org/10.6075/J04Q7SHT)

Adusumilli, S., Fricker, H.A., Medley, B. et al. Interannual variations in meltwater input to the Southern Ocean from Antarctic ice shelves. Nat. Geosci. 13, 616–620 (2020). [https://doi.org/10.1038/s41561-020-0616-z](https://doi.org/10.1038/s41561-020-0616-z)

Greene, C. A., Gwyther, D. E., & Blankenship, D. D. (2017). Antarctic Mapping Tools for Matlab. Computers & Geosciences, 104, 151–157. Elsevier BV. [https://doi.org/10.1016/j.cageo.2016.08.003](https://doi.org/10.1016/j.cageo.2016.08.003)
