use Zepto
select * From dbo.Zepto_Inventory_Cleaned;


/* Section A — Overall Business KPIs

Task 1 — Overall Inventory KPIs */


select 
       Count (Product_Name) as Total_Products,
       Sum (Quantity) as Total_Quantity,
       Sum (available_Quantity) as Total_Available_Quantity,
       Sum (Potential_revenue) as Total_Potential_Revenue,
       Sum (Stock_Value) as Total_Stock_Value,
       Avg (selling_Price) as Average_Selling_Price,
       Avg ([Discount_%]) as Average_Discount 
from dbo.Zepto_Inventory_Cleaned;


/* Task 2 — Product Availability Overview */

SELECT 
       Stock_Status,
       Count (Product_Name) as Product_Count,
       CAST (
             COUNT (*) * 100.0/ 
             SUM ( COUNT (*)) OVER ()
             AS DECIMAL (10,2)
            )
       AS Product_Percentage 
       From zepto_inventory_cleaned
       Group by Stock_Status
       Order by Product_Count;


 /* Section B — Category Performance

    Task 1 — Overall Category Performance   */


 select 
       corrected_category,
       Count (Product_Name) as Total_Products,
       Sum (Quantity) as Total_Quantity,
       Sum (Potential_revenue) as Total_Potential_Revenue,
       Sum (Stock_Value) as Total_Stock_Value,
       cast (Avg(selling_Price) as decimal (10,2)) as Average_Selling_Price,
       cast (Avg([Discount_%]) as decimal (10,2)) as Average_Discount 
 from dbo.Zepto_Inventory_Cleaned
 Group by Corrected_Category
 Order by Total_Potential_Revenue DESC


 /* Section C — Top Products 

    Task 1 — Top 10 Products by Potential Revenue */


  SELECT 
     TOP 10
        Product_Name,
        Potential_Revenue
        From zepto_inventory_cleaned
        Order by Potential_Revenue DESC;


    /* Task 2  — Top 10 Products by Stock Value */


  SELECT 
     TOP 10
        Product_Name,
        Stock_Value
        From zepto_inventory_cleaned
        Order by Stock_Value DESC;


/* Section D — Inventory / Stock Analysis

     Task 1 — Out-of-Stock Analysis   */

     SELECT 
           Corrected_Category,
           Product_Name,
           Potential_Revenue,
           selling_Price,
           stock_Status
           From zepto_inventory_cleaned
           Where Stock_Status IN ('Out of Stock')
           Order by Selling_Price DESC

           
     /* Task 2 — Low-Stock Analysis */

     SELECT
           Corrected_Category,
           Product_name,
           Selling_Price,
           Potential_Revenue,
           Stock_Status
           from zepto_inventory_cleaned
           where Stock_Status = 'Low stock'
           Order by Potential_Revenue DESC
           


   /* Section E — Discount Analysis

       Task 1 — Overall Discount Analysis */

      
      SELECT
            avg ([Discount_%]) as Average_Discount,
            min ([Discount_%]) as Minimum_Discount,
            max ([Discount_%]) as Maximum_Discount,
            Sum (Discount_Amount) as Total_Discount_amount
          from zepto_inventory_cleaned


      /* Task 2  — High-Discount Products */


      SELECT  
            Product_Name,
            Discount_amount,
            [Discount_%] 
            From zepto_inventory_cleaned
         where [Discount_%] > 30
         Order by [Discount_%] DESC
 

      /* Task 3 — Average Discount by Category */


      SELECT 
            Corrected_Category,
            CAST (Avg ([Discount_%]) as Decimal (10,2)) as Average_Discount
         from zepto_inventory_cleaned
         Group by Corrected_Category
         Order by Average_Discount DESC


      /* Task 4 — Discount Band Analysis */

      SELECT
            Discount_Band,
            Count (Product_Name) as Total_Product
            From zepto_inventory_cleaned
            Group by Discount_Band
            Order by Discount_Band ASC


      /* Task 5 — High Discount + High Revenue Products */

      SELECT 
            Product_Name,
            [discount_%],
            Potential_Revenue
         From zepto_inventory_cleaned
         where [discount_%] >= 30 
         AND Potential_Revenue >
                ( 
                  SELECT 
                       Avg (Potential_Revenue) 
                       from zepto_inventory_cleaned
                )
         Order by Potential_Revenue DESC 

    
    /* Section F — PRIZE ANALYSIS

         Task 1 — Price Band Analysis */

       SELECT
             Price_Band,
             Count (Product_Name) as Product_count
          From zepto_inventory_cleaned
          Group by Price_Band
          Order by Price_Band 


        /* Task 2 — Average Selling Price by Category */


        SELECT 
              Corrected_Category,
              CAST (avg (selling_Price) as Decimal (10,2)) as Average_Selling_Price
              From zepto_inventory_cleaned
              Group by Corrected_Category
              order by Average_Selling_Price DESC


        /* Task 3 — High Price + Low Stock Products */


         SELECT 
               Corrected_Category,
               Product_Name,
               Selling_Price,
               Stock_Status
             from zepto_inventory_cleaned
             where Stock_Status = 'Low Stock'
             AND Selling_Price > 
                  (
                   SELECT
                         avg (Selling_Price)
                         From zepto_inventory_cleaned
                  )
             Order by Selling_Price DESC


    /*  Section G — Revenue Contribution

          Task 1 — Category Revenue Contribution % */


          SELECT 
                Corrected_Category,
                SUM (Potential_Revenue) as Total_Potential_revenue,
                CAST(
                       SUM (Potential_Revenue) * 100/
                       SUM (SUM(Potential_Revenue)) OVER () as decimal (10,2))
                       as Revenue_Contribution
                from zepto_inventory_cleaned       
                where Potential_Revenue > 
                      (
                       SELECT 
                       avg (Potential_Revenue) as Average_Contribution From zepto_inventory_cleaned)
                order by Potential_Revenue DESC
             


        /* Task 2 — Top Revenue-Contributing Categories */ 




    /* Section H — Inventory Concentration

           Task 1 — Category Inventory Concentration */
