<!-- Version 0.3.5 2014/06/13 -->

<!--
<!--
<!--
<!-- MM 18/8/2014

CHANGELOG
  0.3.5
    - Add Mode to LineServicePatternsSet (Bus, Ferry etc)
    - Add price data to PeriodPass table
  0.3.4
    - Points_geom: set minrefprice for flatfare
    - Fix spaces bug for Flat (i.e. 'Flat ')
  0.3.3 
    - Remove errant whitespace in the DayType refnum field
    - Fix existing databases with: 
        sql> update DayType set refnumber = trim(refnumber)
  0.3.2
    - Add SquirrelSQL URL example to comments.

  0.3.1
    - change filename
    - Add instruction for running on Windows to comments

  0.3.0 
    - Add StoredValue Table
    - Fix PT_Sales table output


USAGE INSTRUCTIONS 

# On Windows

# 1) Using AltovaXML and the XSLT to convert the XML EOD into SQL statements:

#    AltovaXML -xslt1  xml_eod_to_sql.xslt -in EOD_20140603_162348.V17.1.2.xml -out eod_17_1_2_text.sql

# full path example:

C:\Maurice\AT_MM\AltovaXML2010\AltovaXML -xslt1 C:\Maurice\AT_MM\XSLT\xml_eod_to_sql.xslt -in  C:\Maurice\AT_MM\XML_reference\EOD_20140603_162348.V17.1.2.xml -out c:\temp\eod_17_1_2_text.sql

# 2) create a database with a name matching the EOD either using the command line as below or using PGadmin

createdb -E UTF8  -U postgres  -T template0 EOD_17_1_2

# Run the large sql file to populate the "EOD_17_1_2" database. You could probably do this using the PGadmin tool

psql -U postgres -f  c:\temp\eod_17_1_2_text.sql   EOD_17_1_2

# If using SquirrelSQL to access the database the URL for the Alias looks like this: jdbc:postgresql://localhost:5432/EOD_17_1_2

*** END USAGE INSTRUCTIONS -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/">
    drop table DayType;
    create table DayType  (RefNumber VARCHAR(12),ShortName VARCHAR(30),Name VARCHAR(50),DaysOfWeekBitfield VARCHAR(12),CalendarRefNumber VARCHAR(12)) ;

    
    <xsl:for-each select="TicketingConfiguration/Common/Container/Time/DayTypesSet/DayType">
      insert into DayType (RefNumber ,ShortName ,Name ,DaysOfWeekBitfield,CalendarRefNumber ) values ('<xsl:value-of select="@RefNumber"/>' , '<xsl:value-of select="@ShortName"/>' , '<xsl:value-of select="@Name"/>' , '<xsl:value-of select="./IncludedDayType/DaysOfWeekBitfield"/>' , '<xsl:value-of select="./IncludedDayType/CalendarRefNumber"/>' );
    </xsl:for-each>


    drop table DomainsPointsSet;
    create table DomainsPointsSet ( id integer, D_RefNumber VARCHAR(12), D_Name VARCHAR(40), Abbreviation VARCHAR(12) , RefNumber VARCHAR(12) ,Name VARCHAR(80),Type VARCHAR(24),Attribute VARCHAR(24), GPSCircleCenterLat VARCHAR(12),GPSCircleCenterLong  VARCHAR(12),GPSCircleRadius  VARCHAR(6), tested_used boolean DEFAULT FALSE, tested  boolean DEFAULT FALSE ) ;


    
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/DomainsDefinition/RootDomain/PointsSet/Point">
     insert into DomainsPointsSet (id, D_RefNumber, D_Name ,Abbreviation ,RefNumber ,Name,Type , Attribute, GPSCircleCenterLat  ,GPSCircleCenterLong  ,GPSCircleRadius ) values (<xsl:number/> , '<xsl:value-of select="../../@RefNumber"/>' , '<xsl:value-of select="../../@Name"/>' , '<xsl:value-of select="@Abbreviation"/>' , '<xsl:value-of select="@RefNumber"/>' , '<xsl:value-of select='translate(@Name, "&apos;", " ")'/>' , '<xsl:value-of select="Type"/>' , '<xsl:value-of select="Attribute"/>' , '<xsl:value-of select="GPSCircleCenterLat"/>' , '<xsl:value-of select="GPSCircleCenterLong"/>' , '<xsl:value-of select="GPSCircleRadius"/>' );
    </xsl:for-each>

    
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/DomainsDefinition/RootDomain/SubDomains/Domain/PointsSet/Point">
     insert into DomainsPointsSet (id, D_RefNumber, D_Name ,Abbreviation ,RefNumber ,Name,Type ,Attribute,GPSCircleCenterLat  ,GPSCircleCenterLong  ,GPSCircleRadius ) values  ( <xsl:number/>, '<xsl:value-of select="../../@RefNumber"/>' , '<xsl:value-of select="../../@Name"/>' , '<xsl:value-of select="@Abbreviation"/>' , '<xsl:value-of select="@RefNumber"/>' , '<xsl:value-of select='translate(@Name, "&apos;", " ")'/>' , '<xsl:value-of select="Type"/>' , '<xsl:value-of select="Attribute"/>' , '<xsl:value-of select="GPSCircleCenterLat"/>' , '<xsl:value-of select="GPSCircleCenterLong"/>' , '<xsl:value-of select="GPSCircleRadius"/>' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/DomainsDefinition/RootDomain/SubDomains/Domain/SubDomainsSet/Domain/PointsSet/Point"> 	
     insert into DomainsPointsSet (id, D_RefNumber, D_Name ,Abbreviation ,RefNumber ,Name,Type ,Attribute,GPSCircleCenterLat  ,GPSCircleCenterLong  ,GPSCircleRadius ) values  ( <xsl:number/> , 	'<xsl:value-of select="../../@RefNumber"/>' , 	'<xsl:value-of select="../../@Name"/>' , 	'<xsl:value-of select="@Abbreviation"/>' , 	'<xsl:value-of select="@RefNumber"/>' , 	'<xsl:value-of select='translate(@Name, "&apos;", " ")'/>' , 	'<xsl:value-of select="Type"/>' , 	'<xsl:value-of select="Attribute"/>' , 	'<xsl:value-of select="GPSCircleCenterLat"/>' , 	'<xsl:value-of select="GPSCircleCenterLong"/>' , 	'<xsl:value-of select="GPSCircleRadius"/>');
    </xsl:for-each>

    <xsl:text>
      drop table GroupOfLines;
      create table GroupOfLines ( id integer, RefNumber VARCHAR(12),LineRefNumber VARCHAR(12)) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/LinesDefinition/GroupsOfLinesSet/GroupOfLines/LineRefNumber">
     insert into GroupOfLines ( id, RefNumber, LineRefNumber  ) values (<xsl:number/> ,'<xsl:value-of select="../@RefNumber"/>' ,'<xsl:value-of select="."/>'  );
    </xsl:for-each>

    <xsl:text>
      drop table GroupOfOperators;
      create table GroupOfOperators (id integer, ShortName VARCHAR(32),Name VARCHAR(64), RefNumber VARCHAR(12),OperatorRefNumber VARCHAR(12) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/OperatorsDefinition/GroupsOfOperatorsSet/GroupOfOperators/OperatorRefNumber">
     insert into GroupOfOperators (id, ShortName ,Name, RefNumber, OperatorRefNumber) values (<xsl:number/> ,	'<xsl:value-of select="../@ShortName"/>' ,'<xsl:value-of select="../@Name"/>' ,'<xsl:value-of select="../@RefNumber"/>' , 
      '<xsl:value-of select="."/>' );
    </xsl:for-each>

    <xsl:text>
      drop table GroupOfPoints;
      create table GroupOfPoints ( id integer, ShortName VARCHAR(12),Name VARCHAR(24),RefNumber VARCHAR(8), Type VARCHAR(24),PointRefNumber VARCHAR(8) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/DomainsDefinition/GroupsOfPointsSet/GroupOfPoints/PointRefNumber">
      insert into GroupOfPoints ( id, ShortName, Name, RefNumber, Type ,PointRefNumber  ) values (<xsl:number/> ,'<xsl:value-of select="../@ShortName"/>' ,'<xsl:value-of select="../@Name"/>' ,	'<xsl:value-of select="../@RefNumber"/>' ,'<xsl:value-of select="../Type"/>' ,'<xsl:value-of select="."/>'  );
    </xsl:for-each>

    <xsl:text>
      drop table InitialFee;
      create table InitialFee ( id integer, Operator VARCHAR(6),ShortName VARCHAR(20), Name VARCHAR(40), RefNumber VARCHAR(6) , InitialLegFee VARCHAR(6) ,VIADiscount VARCHAR(6),FareLevel VARCHAR(6),TimeTableRefNumber VARCHAR(6),DomainRefNumber  VARCHAR(6),ProfileRefNumber  VARCHAR(6) ) ;	
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/StoredValue/Pricing/ContractTariffSet/ContractTariff/InitialLegFeeSet/InitialLegFeePerOperator/OperatorSet/OperatorRefNumber">
      insert into InitialFee (id, Operator, ShortName, Name ,RefNumber ,InitialLegFee ,VIADiscount, FareLevel,TimeTableRefNumber,DomainRefNumber,ProfileRefNumber) values (<xsl:number/> , '<xsl:value-of select="."/>' , '<xsl:value-of select="../../../../@ShortName"/>' , '<xsl:value-of select="../../../../@Name"/>' , '<xsl:value-of select="../../../../@RefNumber"/>' , '<xsl:value-of select="../../InitialLegFee"/>' , '<xsl:value-of select="../../../../ConcessionFareType/VIADiscount"/>' , '<xsl:value-of select="../../../../ConcessionFareType/FareLevel"/>' , '<xsl:value-of select="../../../../ConcessionFareType/TimeTableRefNumber"/>' , '<xsl:value-of select="../../../../ConcessionFareType/DomainRefNumber"/>' , '<xsl:value-of select="../../../../ConcessionFareType/Validity/ProfileMandatory/ProfileRefNumber"/>' );
    </xsl:for-each>

    <xsl:text>
      drop table LineServicePatternsSet;
      create table LineServicePatternsSet ( id integer,  OperatorRefNumber VARCHAR(12), PublicNumber VARCHAR(12),ShortName VARCHAR(24),Name VARCHAR(80),LineRefNumber VARCHAR(12),SPRefNumber VARCHAR(12),IsFareCap boolean,IsTransfer boolean,IsConcession boolean, PointRefNumber VARCHAR(12), EntryStage VARCHAR(12), ExitStage VARCHAR(12), FloatingArea VARCHAR(12), Mode VARCHAR(6) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/LinesDefinition/BusLinesSet/BusLine/LineServicePatternsSet/ServicePattern/OrderedPointsOfServicePattern">
      insert into LineServicePatternsSet ( id, OperatorRefNumber, PublicNumber ,ShortName ,Name ,LineRefNumber,SPRefNumber  ,IsFareCap  ,IsTransfer  ,IsConcession  ,PointRefNumber  ,EntryStage  ,ExitStage, FloatingArea, Mode  ) values (<xsl:number/> , '<xsl:value-of select="../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../@PublicNumber"/>' , '<xsl:value-of select="../../../@ShortName"/>' , '<xsl:value-of select="../../../@Name"/>' , '<xsl:value-of select="../../../@RefNumber"/>' , '<xsl:value-of select="../@RefNumber"/>' , <xsl:value-of select="../IsFareCapDiscountAllowed"/> , <xsl:value-of select="../IsTransferDiscountAllowed"/> , <xsl:value-of select="../IsConcessionDiscountAllowed"/> , '<xsl:value-of select="PointRefNumber"/>' , '<xsl:value-of select="EntryStage"/>' , '<xsl:value-of select="ExitStage"/>'  , '<xsl:value-of select="FloatingArea"/>', 'Bus' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/LinesDefinition/FerryLinesSet/FerryLine/ServicePattern/OrderedPointsOfServicePattern">
      insert into LineServicePatternsSet ( id, OperatorRefNumber, PublicNumber ,ShortName ,Name ,LineRefNumber,SPRefNumber  ,IsFareCap  ,IsTransfer  ,IsConcession  ,PointRefNumber  ,EntryStage  ,ExitStage, FloatingArea, Mode  ) values (<xsl:number/> , '<xsl:value-of select="../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../@PublicNumber"/>' , '<xsl:value-of select="../../@ShortName"/>' , '<xsl:value-of select="../../@Name"/>' , '<xsl:value-of select="../../@RefNumber"/>' , '<xsl:value-of select="../@RefNumber"/>' , <xsl:value-of select="../IsFareCapDiscountAllowed"/> , <xsl:value-of select="../IsTransferDiscountAllowed"/> , <xsl:value-of select="../IsConcessionDiscountAllowed"/> , '<xsl:value-of select="PointRefNumber"/>' , '<xsl:value-of select="EntryStage"/>' , '<xsl:value-of select="ExitStage"/>'  , '<xsl:value-of select="FloatingArea"/>', 'Ferry' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/LinesDefinition/TrainLinesSet/TrainLine/ServicePattern/OrderedPointsOfServicePattern">
      insert into LineServicePatternsSet ( id, OperatorRefNumber, PublicNumber ,ShortName ,Name ,LineRefNumber,SPRefNumber  ,IsFareCap  ,IsTransfer  ,IsConcession  ,PointRefNumber  ,EntryStage  ,ExitStage, FloatingArea, Mode  ) values (<xsl:number/> , '<xsl:value-of select="../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../@PublicNumber"/>' , '<xsl:value-of select="../../@ShortName"/>' , '<xsl:value-of select="../../@Name"/>' , '<xsl:value-of select="../../@RefNumber"/>' , '<xsl:value-of select="../@RefNumber"/>' , <xsl:value-of select="../IsFareCapDiscountAllowed"/> , <xsl:value-of select="../IsTransferDiscountAllowed"/> , <xsl:value-of select="../IsConcessionDiscountAllowed"/> , '<xsl:value-of select="PointRefNumber"/>' , '<xsl:value-of select="EntryStage"/>' , '<xsl:value-of select="ExitStage"/>'  , '<xsl:value-of select="FloatingArea"/>', 'Train' );
    </xsl:for-each>

    <xsl:text>
      drop table LineTripsSet;
      create table LineTripsSet ( id integer, RefNumber VARCHAR(12), PublicNumber VARCHAR(12) ,DepartureTime VARCHAR(12) ,DayTypeRefNumber VARCHAR(12),TimePeriodType VARCHAR(24),ServicePatternRefNumber VARCHAR(12) ,SpecificServiceType VARCHAR(24)) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/LinesDefinition/BusLinesSet/BusLine/LineTripsSet/Trip">
      insert into LineTripsSet ( id, RefNumber, PublicNumber ,DepartureTime ,DayTypeRefNumber ,TimePeriodType,ServicePatternRefNumber  ,SpecificServiceType   ) values (<xsl:number/> , '<xsl:value-of select="@RefNumber"/>' , '<xsl:value-of select="PublicNumber"/>' , '<xsl:value-of select="DepartureTime"/>' , '<xsl:value-of select="DayTypeRefNumber"/>' , '<xsl:value-of select="TimePeriodType"/>' , '<xsl:value-of select="ServicePatternRefNumber"/>' , '<xsl:value-of select="SpecificServiceType"/>' );
    </xsl:for-each>

    <xsl:text>
      drop table OperatorsSet;
      create table OperatorsSet ( RefNumber VARCHAR(12),Abbreviation VARCHAR(12),ShortName VARCHAR(32),Name VARCHAR(64) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/OperatorsDefinition/OperatorsSet/Operator">
      insert into OperatorsSet (RefNumber ,Abbreviation ,ShortName ,Name) values ('<xsl:value-of select="@RefNumber"/>' , '<xsl:value-of select="@Abbreviation"/>' ,	'<xsl:value-of select="@ShortName"/>' ,	'<xsl:value-of select="@Name"/>' );
    </xsl:for-each>

    <xsl:text>
      drop table PaperTicket;
      create table PaperTicket ( id integer, FareLevel VARCHAR(6),MinNbOfStages VARCHAR(6), MaxNbOfStages VARCHAR(6), Price VARCHAR(6),OperatorRefNumber VARCHAR(6) ,Abbreviation VARCHAR(6),ShortName VARCHAR(20),Name VARCHAR(40),RefNumber  VARCHAR(6), DateOfStartOfSale  date, DateOfEndOfSale Date, DateOfStartOfUse Date, DateOfEndOfUse Date, Retail_Operator VARCHAR(6) , Retail_GroupOfOperators VARCHAR(6) , Percentage VARCHAR(6),BusinessEntity VARCHAR(6) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PaperTicketSet/PaperTicket/PaperTicketNbStages/Pricing/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
      insert into PaperTicket (id, FareLevel, MinNbOfStages, MaxNbOfStages ,Price ,OperatorRefNumber ,Abbreviation, ShortName,Name,RefNumber,DateOfStartOfSale,DateOfEndOfSale,DateOfStartOfUse,DateOfEndOfUse,Retail_Operator,Retail_GroupOfOperators,Percentage,BusinessEntity) values (<xsl:number/> , '<xsl:value-of select="FareLevel"/>' , '<xsl:value-of select="MinNbOfStages"/>' , '<xsl:value-of select="MaxNbOfStages"/>' , '<xsl:value-of select="Price"/>' , '<xsl:value-of select="../../../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../@Abbreviation"/>' , '<xsl:value-of select="../../../../../@ShortName"/>' , '<xsl:value-of select="../../../../../@Name"/>' , '<xsl:value-of select="../../../../../@RefNumber"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfUse"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfUse"/>' , '<xsl:value-of select="../../../../../PaperTicketNbStages/FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers/OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../PaperTicketNbStages/FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers/GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../Settlement/FixedRatioPercentages/ApportionmentPercentage/@Percentage"/>' , '<xsl:value-of select="../../../../../Settlement/FixedRatioPercentages/ApportionmentPercentage/@BusinessEntity"/>' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PaperTicketSet/PaperTicket/PaperTicketFlatFare/Pricing/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
      insert into PaperTicket (id, FareLevel, MinNbOfStages, MaxNbOfStages ,Price ,OperatorRefNumber ,Abbreviation, ShortName,Name,RefNumber,DateOfStartOfSale,DateOfEndOfSale,DateOfStartOfUse,DateOfEndOfUse,Retail_Operator,Retail_GroupOfOperators,Percentage,BusinessEntity) values (<xsl:number/> , '<xsl:value-of select="FareLevel"/>' , 'Flat' , 'Flat' , '<xsl:value-of select="Price"/>' , '<xsl:value-of select="../../../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../@Abbreviation"/>' , '<xsl:value-of select="../../../../../@ShortName"/>' , '<xsl:value-of select="../../../../../@Name"/>' , '<xsl:value-of select="../../../../../@RefNumber"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfUse"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfUse"/>' , '<xsl:value-of select="../../../../../PaperTicketFlatFare/FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers/OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../PaperTicketFlatFare/FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers/GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../Settlement/FixedRatioPercentages/ApportionmentPercentage/@Percentage"/>' , '<xsl:value-of select="../../../../../Settlement/FixedRatioPercentages/ApportionmentPercentage/@BusinessEntity"/>' );
    </xsl:for-each>



    <xsl:text>
      drop table PeriodPass;
      create table PeriodPass ( id integer,  OperatorRefNumber VARCHAR(6), Abbreviation VARCHAR(12),ShortName VARCHAR(24),Name VARCHAR(80), RefNumber VARCHAR(12), DateOfStartOfSale  date, DateOfEndOfSale Date, DateOfStartOfUse Date, DateOfEndOfUse Date, FareType VARCHAR(12), IncludedRetailers VARCHAR(6), EditionMask VARCHAR(24), IncludedServiceProvider VARCHAR(6), UnitPeriod VARCHAR(12),SlidingValidity VARCHAR(18),ExcludedLines VARCHAR(6),IncludedZones VARCHAR(6),TariffShortName VARCHAR(24),TariffRefNumber VARCHAR(6),ActualUsage VARCHAR(6), FareLevel VARCHAR(6), MinNbOfZones VARCHAR(6), MaxNbOfZones VARCHAR(6), Price  VARCHAR(6) ) ;
    </xsl:text>


    <xsl:for-each select="/TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PeriodPassSet/PeriodPass/PeriodPassNbZones/Pricing/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
      insert into PeriodPass (id, OperatorRefNumber, Abbreviation, ShortName ,Name ,RefNumber ,DateOfStartOfSale,  DateOfEndOfSale,DateOfStartOfUse,DateOfEndOfUse,FareType,IncludedRetailers,EditionMask,IncludedServiceProvider,UnitPeriod,SlidingValidity, ExcludedLines, IncludedZones, TariffShortName, TariffRefNumber,ActualUsage,FareLevel, MinNbOfZones, MaxNbOfZones, Price) values (<xsl:number/> , '<xsl:value-of select="../../../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../@Abbreviation"/>' , '<xsl:value-of select="../../../../../@ShortName"/>' , '<xsl:value-of select="../../../../../@Name"/>' , '<xsl:value-of select="../../../../../@RefNumber"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfUse"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfUse"/>' , 'NbZones', '<xsl:value-of select="../../../../../PeriodPassNbZones/FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers/GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassNbZones/FunctionalRules/SaleRules/EditionMask"/>' , '<xsl:value-of select="../../../../../PeriodPassNbZones/FunctionalRules/UsageRules/AllowedServiceProviders/IncludedServiceProvider/GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassNbZones/FunctionalRules/Validity/TemporalValidity/SlidingValidity/UnitPeriod"/>' , '<xsl:if test="../../../../../PeriodPassNbZones/FunctionalRules/Validity/TemporalValidity/SlidingValidity/DateToDate">DateToDate</xsl:if> <xsl:if test="../../../../../PeriodPassNbZones/FunctionalRules/Validity/TemporalValidity/SlidingValidity/SlidingCalendar">SlidingCalendar</xsl:if>', '<xsl:value-of select="../../../../../PeriodPassNbZones/FunctionalRules/Validity/GeographicalValidity/SetOfLines/ExcludedLines/GroupOfLinesRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassNbZones/FunctionalRules/Validity/GeographicalValidity/SetOfZones/IncludedZones/GroupOfZonesRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassNbZones/Pricing/ContractTariffSet/ContractTariff/@ShortName"/>' , '<xsl:value-of select="../../../../../PeriodPassNbZones/Pricing/ContractTariffSet/ContractTariff/@RefNumber"/>' , '<xsl:value-of select="../../../../../Settlement/ActualUsage"/>' , '<xsl:value-of select="FareLevel"/>' , '<xsl:value-of select="MinNbOfZones"/>' , '<xsl:value-of select="MaxNbOfZones"/>' , '<xsl:value-of select="Price"/>' );
    </xsl:for-each>


    <xsl:for-each select="/TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PeriodPassSet/PeriodPass/PeriodPassFlatFare/Pricing/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
      insert into PeriodPass (id, OperatorRefNumber, Abbreviation, ShortName ,Name ,RefNumber ,DateOfStartOfSale, DateOfEndOfSale,DateOfStartOfUse,DateOfEndOfUse,FareType,IncludedRetailers,EditionMask,IncludedServiceProvider,UnitPeriod,SlidingValidity, ExcludedLines, IncludedZones, TariffShortName, TariffRefNumber,ActualUsage,FareLevel, MinNbOfZones, MaxNbOfZones, Price) values (<xsl:number/> , '<xsl:value-of select="../../../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../@Abbreviation"/>' , '<xsl:value-of select="../../../../../@ShortName"/>' , '<xsl:value-of select="../../../../../@Name"/>' , '<xsl:value-of select="../../../../../@RefNumber"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfSale"/>' , '<xsl:value-of select="../../../../../Version/DateOfStartOfUse"/>' , '<xsl:value-of select="../../../../../Version/DateOfEndOfUse"/>' , 'FlatFare', '<xsl:value-of select="../../../../../PeriodPassFlatFare/FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers/GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassFlatFare/FunctionalRules/SaleRules/EditionMask"/>' , '<xsl:value-of select="../../../../../PeriodPassFlatFare/FunctionalRules/UsageRules/AllowedServiceProviders/IncludedServiceProvider/GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassFlatFare/FunctionalRules/Validity/TemporalValidity/SlidingValidity/UnitPeriod"/>' , '<xsl:if test="../../../../../PeriodPassFlatFare/FunctionalRules/Validity/TemporalValidity/SlidingValidity/DateToDate">DateToDate</xsl:if>', '<xsl:value-of select="../../../../../PeriodPassFlatFare/FunctionalRules/Validity/GeographicalValidity/SetOfLines/ExcludedLines/GroupOfLinesRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassFlatFare/FunctionalRules/Validity/GeographicalValidity/SetOfZones/IncludedZones/GroupOfZonesRefNumber"/>' , '<xsl:value-of select="../../../../../PeriodPassFlatFare/Pricing/ContractTariffSet/ContractTariff/@ShortName"/>' , '<xsl:value-of select="../../../../../PeriodPassFlatFare/Pricing/ContractTariffSet/ContractTariff/@RefNumber"/>' , '<xsl:value-of select="../../../../../Settlement/ActualUsage"/>', '<xsl:value-of select="FareLevel"/>' , '<xsl:value-of select="MinNbOfZones"/>' , '<xsl:value-of select="MaxNbOfZones"/>' , '<xsl:value-of select="Price"/>' );
    </xsl:for-each>


    <xsl:text>
      drop table PT_SaleRules;
      create table PT_SaleRules ( id integer, type VARCHAR(10), SR_OperatorRefNumber VARCHAR(6),SR_GroupOfOperatorsRefNumber VARCHAR(6), OperatorRefNumber VARCHAR(6) ,Abbreviation VARCHAR(6),ShortName VARCHAR(20),Name VARCHAR(40),RefNumber  VARCHAR(6), BusinessEntity VARCHAR(6) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PaperTicketSet/PaperTicket/PaperTicketNbStages//FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers">
      insert into PT_SaleRules (id, type, SR_OperatorRefNumber, SR_GroupOfOperatorsRefNumber, OperatorRefNumber ,Abbreviation, ShortName,Name,RefNumber,BusinessEntity) values (<xsl:number/> , 'nbstages ' , '<xsl:value-of select="OperatorRefNumber"/>' , '<xsl:value-of select="GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../@Abbreviation"/>' , '<xsl:value-of select="../../../../../@ShortName"/>' , '<xsl:value-of select="../../../../../@Name"/>' , '<xsl:value-of select="../../../../../@RefNumber"/>' , '<xsl:value-of select="../../../../../Settlement/FixedRatioPercentages/ApportionmentPercentage/@BusinessEntity"/>' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PaperTicketSet/PaperTicket/PaperTicketFlatFare//FunctionalRules/SaleRules/AllowedRetailers/IncludedRetailers">
      insert into PT_SaleRules (id, type, SR_OperatorRefNumber, SR_GroupOfOperatorsRefNumber, OperatorRefNumber ,Abbreviation, ShortName,Name,RefNumber,BusinessEntity) values (<xsl:number/> , 'Flat' , '<xsl:value-of select="OperatorRefNumber"/>' , '<xsl:value-of select="GroupOfOperatorsRefNumber"/>' , '<xsl:value-of select="../../../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../../../@Abbreviation"/>' , '<xsl:value-of select="../../../../../@ShortName"/>' , '<xsl:value-of select="../../../../../@Name"/>' , '<xsl:value-of select="../../../../../@RefNumber"/>' , '<xsl:value-of select="../../../../../Settlement/FixedRatioPercentages/ApportionmentPercentage/@BusinessEntity"/>' ); 
    </xsl:for-each>

    <xsl:text>
      drop table Settlement;
      create table Settlement ( id integer, OperatorRefNumber VARCHAR(6),Abbreviation VARCHAR(12), ShortName VARCHAR(20), name VARCHAR(40),RefNumber VARCHAR(6) ,type VARCHAR(20),value VARCHAR(6),Percentage VARCHAR(6),BusinessEntity VARCHAR(6) ) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PeriodPassSet/PeriodPass/Settlement/ActualUsage">
      insert into Settlement (id, OperatorRefNumber, Abbreviation, ShortName ,Name ,RefNumber,type,value,percentage, BusinessEntity) values (<xsl:number/> , '<xsl:value-of select="../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../@Abbreviation"/>' , '<xsl:value-of select="../../@ShortName"/>' , '<xsl:value-of select="../../@Name"/>' , '<xsl:value-of select="../../@RefNumber"/>' , 'ActualUsage', '<xsl:value-of select="."/>' , '','' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PeriodPassSet/PeriodPass/Settlement/FixedRatioPercentages/ApportionmentPercentage">
      insert into Settlement (id, OperatorRefNumber, Abbreviation, ShortName ,Name ,RefNumber,type,value,percentage, BusinessEntity) values (<xsl:number/> , '<xsl:value-of select="../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../@Abbreviation"/>' , '<xsl:value-of select="../../../@ShortName"/>' , '<xsl:value-of select="../../../@Name"/>' , '<xsl:value-of select="../../../@RefNumber"/>' , 'PPFixedRatio', '', '<xsl:value-of select="@Percentage"/>' , '<xsl:value-of select="@BusinessEntity"/>' );
    </xsl:for-each>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/PaperTicketSet/PaperTicket/Settlement/FixedRatioPercentages/ApportionmentPercentage">
      insert into Settlement (id, OperatorRefNumber, Abbreviation, ShortName ,Name ,RefNumber,type,value,percentage, BusinessEntity) values (<xsl:number/> , '<xsl:value-of select="../../../@OperatorRefNumber"/>' , '<xsl:value-of select="../../../@Abbreviation"/>' , '<xsl:value-of select="../../../@ShortName"/>' , '<xsl:value-of select="../../../@Name"/>' , '<xsl:value-of select="../../../@RefNumber"/>' , 'PTFixedRatio', '', '<xsl:value-of select="@Percentage"/>' , '<xsl:value-of select="@BusinessEntity"/>' ); 
    </xsl:for-each>

    <xsl:text>
      drop table StationAccessRightMatrix;
      create table StationAccessRightMatrix ( id  integer,RefNumber VARCHAR(6),GroupOfOriginPointsRefNumber VARCHAR(6),GroupOfDestinationPointsRefNumber VARCHAR(6), OriginPointRefNumber VARCHAR(6), DestinationPointRefNumber VARCHAR(6), TransferLineRefNumber VARCHAR(6), TransferPointRefNumber VARCHAR(6)) ;
    </xsl:text>

      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/MatrixesDefinition/AccessRightMatrixes/StationAccessRightMatrixesSet/GlobalStationAccessRightMatrix/CellOfStationAccessRightMatrix">
      insert into StationAccessRightMatrix ( id, RefNumber, GroupOfOriginPointsRefNumber, GroupOfDestinationPointsRefNumber, OriginPointRefNumber, DestinationPointRefNumber, TransferLineRefNumber, TransferPointRefNumber ) values (<xsl:number/> , '<xsl:value-of select="../@RefNumber"/>' , '<xsl:value-of select="GroupOfOriginPointsRefNumber"/>' , '<xsl:value-of select="GroupOfDestinationPointsRefNumber"/>' , '<xsl:value-of select="OriginPointRefNumber"/>' , '<xsl:value-of select="DestinationPointRefNumber"/>' , '<xsl:value-of select="TransferLineRefNumber"/>' , '<xsl:value-of select="TransferPointRefNumber"/>' ); 
    </xsl:for-each>


    <xsl:text>
      drop table PointToPointMatrixesSet;
      create table PointToPointMatrixesSet ( RefNumber VARCHAR(6),IsSymmetric VARCHAR(6),LineRefNumber VARCHAR(6), OriginPointRefNumber VARCHAR(6), DestinationPointRefNumber VARCHAR(6),  PriceIndex VARCHAR(6)) ;
    </xsl:text>


    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/MatrixesDefinition/FareMatrixesSet/PointToPointMatrixesSet/PointToPointMatrix/PriceIndex/CellOfPointToPointMatrix">
      insert into PointToPointMatrixesSet ( RefNumber, IsSymmetric, LineRefNumber, OriginPointRefNumber, DestinationPointRefNumber,  PriceIndex ) values ( '<xsl:value-of select="../../@RefNumber"/>' , '<xsl:value-of select="../../IsSymmetric"/>' , '<xsl:value-of select="../../LineRefNumber"/>' , '<xsl:value-of select="OriginPointRefNumber"/>' , '<xsl:value-of select="DestinationPointRefNumber"/>' , '<xsl:value-of select="PriceIndex"/>' );
    </xsl:for-each>


    <xsl:text>
      drop table ZonesPointsSet;
      create table ZonesPointsSet ( id integer,ShortName VARCHAR(12),Name VARCHAR(12),RefNumber VARCHAR(3), Type VARCHAR(24),Stop_id VARCHAR(6) ) ;
    </xsl:text>
      
    <xsl:for-each select="TicketingConfiguration/Common/Container/Topology/DomainsDefinition/RootDomain/ZonesSet/Zone/PointsSet/PointRefNumber">
      insert into ZonesPointsSet (id, ShortName, Name ,RefNumber ,Type ,stop_id ) values (<xsl:number/> , '<xsl:value-of select="../../@ShortName"/>' , '<xsl:value-of select="../../@Name"/>' , '<xsl:value-of select="../../@RefNumber"/>' , '<xsl:value-of select="../../Type"/>' , '<xsl:value-of select="."/>'); 
    </xsl:for-each>

    <!-- ****************** -->
    <!-- TABLE: StoredValue -->
    <!-- ****************** -->
    <xsl:text>
      drop table StoredValue;
    create table StoredValue ( id integer, Name VARCHAR(20),DomainRefNumber VARCHAR(6), FareLevel VARCHAR(6), TimePeriodType VARCHAR(20), MinRefPrice VARCHAR(6) ,MaxRefPrice VARCHAR(6),Price VARCHAR(6),section VARCHAR(20) ) ;
    </xsl:text>

    <xsl:for-each select="TicketingConfiguration/Common/Container/Fare/ProductsDefinition/StoredValue/Pricing/DomainFareTableAtUse">
        <xsl:for-each select="DomainFareStructure/DomainFareStructureDistanceRefPrice/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
            insert into StoredValue ( id, Name, DomainRefNumber ,FareLevel ,TimePeriodType ,MinRefPrice,MaxRefPrice  ,Price, section   ) values (<xsl:number/> , 	'<xsl:value-of select="../../../../../../../@Name"/>' , 	'<xsl:value-of select="../../../DomainRefNumber"/>' , 	'<xsl:value-of select="FareLevel"/>' , 	'<xsl:value-of select="TimePeriodType"/>' , 	'<xsl:value-of select="MinRefPrice"/>' , 	'<xsl:value-of select="MaxRefPrice"/>' , 	'<xsl:value-of select="Price"/>' , 'Distance' );
        </xsl:for-each>

        <xsl:for-each select="DomainFareStructure/DomainFareStructureNbStages/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
            insert into StoredValue ( id, Name, DomainRefNumber ,FareLevel ,TimePeriodType ,MinRefPrice,MaxRefPrice  ,Price, section   ) values (<xsl:number/> , 	'<xsl:value-of select="../../../../../../../@Name"/>' , 	'<xsl:value-of select="../../../DomainRefNumber"/>' , 	'<xsl:value-of select="FareLevel"/>' , 	'<xsl:value-of select="TimePeriodType"/>' , 	'<xsl:value-of select="MinNbOfStages"/>' , 	'<xsl:value-of select="MaxNbOfStages"/>' , 	'<xsl:value-of select="Price"/>' , 'NBstages' );
        </xsl:for-each>

        <xsl:for-each select="DomainFareStructure/DomainFareStructureFlatFare/FareStructure/FareCalculationMatrix/CellOfFareCalculationMatrix">
            insert into StoredValue ( id, Name, DomainRefNumber ,FareLevel ,TimePeriodType ,MinRefPrice,MaxRefPrice  ,Price, section   ) values (<xsl:number/> , 	'<xsl:value-of select="../../../../../../../@Name"/>' , 	'<xsl:value-of select="../../../DomainRefNumber"/>' , 	'<xsl:value-of select="FareLevel"/>' , 	'<xsl:value-of select="TimePeriodType"/>' , 	'<xsl:value-of select="MinNbOfStages"/>' , 	'<xsl:value-of select="MaxNbOfStages"/>' , 	'<xsl:value-of select="Price"/>' , 'Flatfare' );
        </xsl:for-each>
    </xsl:for-each>

    <xsl:text>
      <!-- Define minrefprice specifically as 'Flat' where it's not set. Should only be for Flatfare sections -->
      update STOREDVALUE set minrefprice = 'Flat' where minrefprice = '' and section = 'Flatfare' ;
    </xsl:text>

    <!-- ****************** -->
    <!-- TABLE: Points_geom -->
    <!-- ****************** -->
    <xsl:text>
      CREATE EXTENSION postgis;

      CREATE EXTENSION adminpack;

      drop table Points_geom;

      create table Points_geom (Abbreviation VARCHAR(12) , RefNumber VARCHAR(12) ,Name VARCHAR(80),Type VARCHAR(24),Radius  VARCHAR(6), maptext VARCHAR(80),the_circle geometry(POLYGON,4326) ,the_geom geometry(POINT,4326) ) ;

      UPDATE POINTS_GEOM SET the_geom = ST_SetSRID(the_geom,4326);

      insert into POINTS_GEOM (Abbreviation, RefNumber, Name, Type, Radius, maptext, the_geom) SELECT Abbreviation, refnumber, Name, Type, gpscircleradius,'ryry' as maptext,ST_Transform(ST_GeomFromText('POINT('||left(gpscirclecenterlong,7)||' '||left(gpscirclecenterlat,7)||')',2193),4326)  as the_geom from DomainsPointsSet;

      update Points_geom set maptext = ST_Y(the_geom)||' '||ST_X(the_geom) ;

      update Points_geom set the_circle = (ST_Buffer((the_geom)::geography,to_number(radius,'999D9S' ))::geometry)  ;
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>
