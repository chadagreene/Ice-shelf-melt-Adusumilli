# Description 
These Matlab functions load (and calculate when necessary) melt rates from [Adusumilli et al's 2020 dataset](https://library.ucsd.edu/dc/object/bb0448974g). The functions include:

- `melt_data_adusumilli` loads either the 500 m resolution composite melt rate map, or the 10 km time series. As distributed, the time series data do not actually include melt rates, so this function converts surface elevation anomalies into basal melt rates. 
- `melt_interp_adusumilli` simply interpolates the 500 m resolution composite melt rate map. 

The easiest way to see how to work with these functions is to make sure Matlab can find all the contents of these folders and then type 

    showdemo melt_data_adusumilli_documentation

into the Matlab command window. Or just find the `melt_data_adusumilli_documentation.html` file and open it in a web browser. Same goes for `melt_data_adusumilli_documentation`.

# Requirements 
All you need is the data and AMT. 

- Both melt datasets found under the **Components** link [here](https://library.ucsd.edu/dc/object/bb0448974g).
- Antarctic Mapping Tools for Matlab found [here](https://www.mathworks.com/matlabcentral/fileexchange/47638).
- (optional) Climate Data Toolbox for Matlab found [here](https://github.com/chadagreene/CDT). This is only if you want an antialiasing option for melt rate interpolation. 


# Citation 
Please cite Susheel's dataset and/or paper! It's probably also scientifically prudent to cite Antarctic Mapping Tools because the conversion from surface elevation to melt rate is performed by this function. 

- Adusumilli, Susheel; Fricker, Helen A.; Medley, Brooke C.; Padman, Laurie; Siegfried, Matthew R. (2020). Data from: Interannual variations in meltwater input to the Southern Ocean from Antarctic ice shelves. UC San Diego Library Digital Collections. Adusumilli, Susheel; Fricker, Helen A.; Medley, Brooke C.; Padman, Laurie; Siegfried, Matthew R. (2020). Data from: Interannual variations in meltwater input to the Southern Ocean from Antarctic ice shelves. UC San Diego Library Digital Collections. [https://doi.org/10.6075/J04Q7SHT](https://doi.org/10.6075/J04Q7SHT)

- Adusumilli, S., Fricker, H.A., Medley, B. et al. Interannual variations in meltwater input to the Southern Ocean from Antarctic ice shelves. Nat. Geosci. 13, 616–620 (2020). [https://doi.org/10.1038/s41561-020-0616-z](https://doi.org/10.1038/s41561-020-0616-z)

- Greene, C. A., Gwyther, D. E., & Blankenship, D. D. (2017). Antarctic Mapping Tools for Matlab. Computers & Geosciences, 104, 151–157. Elsevier BV. [https://doi.org/10.1016/j.cageo.2016.08.003](https://doi.org/10.1016/j.cageo.2016.08.003)
