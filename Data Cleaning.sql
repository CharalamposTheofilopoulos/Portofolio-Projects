
select * 
from NashvilleHousing

-- Standardize Date Format
select SaleDate ,CONVERT(Date, SaleDate)
from NashvilleHousing

-- Add a new column which will has the correct data format
Alter Table NashvilleHousing
Add SaleDateConverted Date;

-- Update the new collumn to the correct data format
Update NashvilleHousing 
Set SaleDateConverted = Convert(Date, SaleDate)

-- Visualize the new column compared to the old column
Select SaleDate, SaleDateConverted
From NashvilleHousing

---------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select PropertyAddress 
from NashvilleHousing
order by PropertyAddress

Select *
from NashvilleHousing
where PropertyAddress is null

-- Filling the null rows (PropertyAddress with the proper values)
Select a.ParcelID, a.PropertyAddress , b.ParcelID, b.PropertyAddress--, ISNULL(a.PropertyAddress, b.PropertyAddress) as PropertyAddressFilled
from NashvilleHousing a
Join NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--------------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State) 

Select PropertyAddress
From NashvilleHousing

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) as Address,
Substring(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 , Len(PropertyAddress) ) as Address2
From NashvilleHousing

Alter Table NashvilleHousing
Add Address Nvarchar(255);

Update NashvilleHousing
Set Address = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 )

Alter Table NashvilleHousing
Add City Nvarchar(255);

Update NashvilleHousing
Set City = Substring(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 , Len(PropertyAddress) )

Select * 
From NashvilleHousing


Select OwnerAddress
From NashvilleHousing

-- Parsename () works with '.' instead of ',' , thus the replacement . Moreover the indexing works from  right to left.
Select
Parsename(Replace(OwnerAddress, ',', '.') , 3),
Parsename(Replace(OwnerAddress, ',', '.') , 2),
Parsename(Replace(OwnerAddress, ',', '.') , 1)
From NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.') , 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.') , 2)


Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.') , 1)

Select OwnerAddress 
From NashvilleHousing

Select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
From NashvilleHousing


--------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" column


Select Distinct(SoldAsVacant) , Count(*)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldAsVacant
		 End
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldAsVacant
		 End

-----------------------------------------------------------------------------------------------

-- Remove Duplicates using CTE
WITH RowNumCTE AS (
Select *, 
	ROW_NUMBER() OVER(
	PARTITION BY 
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
					UniqueID
				) row_num 	
From NashvilleHousing
--Order by ParcelID
)
--Delete 
--From RowNumCTE
--Where row_num > 1


Select * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select * 
From NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, PropertyAddress , SaleDate









