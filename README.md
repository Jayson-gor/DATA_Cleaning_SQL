# Data Cleaning in SQL
This project involves data cleaning using SQL to process and transform a dataset called NationalHousing. The dataset contains various columns related to property sales and ownership information. The objective of this project was to standardize the data, handle missing values, and improve data quality for further analysis.

## Steps Performed
### Viewing Top 1000 Rows in Each Column
To get a glimpse of the data, I retrieved the top 1000 rows from each column of the NationalHousing table.

### Standarizing the Date Format
The SaleDate column required standardization to a date format. I used the CONVERT function to convert the SaleDate values to the desired date format and created a new column called SaleDateClean.

### Populating Property Address Data
I identified missing values in the PropertyAddress column and used a self-join operation to populate the missing values based on matching ParcelID and UniqueID values from other rows in the dataset.

### Breaking Property Address into Individual Columns
To enhance data granularity, I split the PropertyAddress column into separate columns for Address, City, and State. We used substring and character index functions to extract the relevant parts of the address.

### Splitting Owner Address
Similar to the PropertyAddress, I split the OwnerAddress column into separate columns for Address, City, and State. I employed two methods - substring and character index functions, and the PARSENAME function - to extract the desired parts of the address.

### Handling 'SoldAsVacant' Column
I examined the distinct values in the SoldAsVacant column and decided to change 'Y' and 'N' to 'Yes' and 'No' respectively. I utilized a case statement to perform the transformation and updated the values in the SoldAsVacant column.

### Identifying and Deleting Duplicates
I identified duplicate records in the dataset based on specific columns using the ROW_NUMBER function. I retrieved the duplicate rows and then deleted them from the NationalHousing table, ensuring data integrity and eliminating redundancy.

## Conclusion
The SQL queries performed in this data cleaning project demonstrate various techniques for handling data quality issues, such as standardizing date formats, populating missing values, splitting columns, transforming values, and removing duplicates. By following these steps, the dataset has been cleansed and prepared for further analysis, ensuring accurate and reliable results.

For more details and the complete SQL script, refer to the SQL_Cleaning_Project.sql file in this repository.

Please note that this project assumes basic knowledge of SQL and familiarity with the NationalHousing dataset.
