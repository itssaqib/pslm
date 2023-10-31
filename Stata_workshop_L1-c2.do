* 2017.3.10
* Stata Workshop Level 1. Class2.
* by Seulki Choi

cd E:/data
pwd

*******************************
* Data management: merge      *
*******************************

use autosize, clear 
edit
use autoexpense, clear
edit
merge 1:1 make using autoexpense
edit





*******************************
* Data management: collapse   *
*******************************

use college, clear
describe
list
list, sep(4)
list, sepby(year)
collapse *



use college, clear
collapse (mean) gpa hour (max) year (min) number
collapse (mean) gpa hour            (min) number, by(year)


******************************
* Data management: reshape   *
******************************

use nlsy7904_commonkey, clear
list in 1/5
list in -5/l
edit
summarize
codebook pid
drop dobmonth dobyear woi* doi*
order pid sampleid race sex weight* age* enroll* edu* marital* 

* reshape from wide to long
* reshape long inc, i(pid) j(year)
* reshape wide inc, i(pid) j(year)




* Describe
use global1, clear
list in 1/5
summarize temp if year <1970
summ      temp if year >=1970
su        temp if (month==1 | month==2) & year>=1940
tabulate  month
tab       month
ta        month
tab1      year month 



* egen
use global1, clear
su temp
display r(mean)
return list
gen  avgtemp       = r(mean)
egen avgtemp_all   = mean(temp)
edit

bysort month: egen avgtemp_month = mean(temp)

egen a1=rowmean(avgtemp_all avgtemp_month)

help egen



* Date
use global1, clear
gen edate = mdy(month, 15, year)
list in 1/5

format edate %tdmcy    /*  format edate as a date variable(%td) showing month(m), century(c) and year(y)   */
list in 1/5




* recode
use global1, clear
tab month
gen      half = 1 if month<7
replace  half = 2 if month>=7
tab half

gen half2=month  
recode half2 (1/6=1) (7/12=2)
tab half2
recode month (1/6=1) (7/12=2), gen(half3)
tab half3
sort year month
edit


use global1, clear
tab year
recode year (1880/1899 = 1880) (1891/1899 = 1890) (1900/1909 = 1900) (1910/1919=1910) (1920/1929=1920) (1930/1939=1930) (1940/1949=1940) (1950/1959=1950) (1960/1969=1960) (1970/1979=1970) (1980/1989=1980) (1990/1999=1990) (2000/2009=2000) (2010/2019=2010), gen(y10)

recode year (1880/1899=1880) (1891/1899=1890) (1900/1909=1900) ///
            (1910/1919=1910) (1920/1929=1920) (1930/1939=1930) /// 
            (1940/1949=1940) (1950/1959=1950) (1960/1969=1960) ///
            (1970/1979=1970) (1980/1989=1980) (1990/1999=1990) ///
            (2000/2009=2000) (2010/2019=2010), gen(year10)

edit


* creating categorical variables
use global1, clear
tab month, gen(month)

gen     half4=0 if month<7
replace half4=1 if month>=7
gen     half5=     month>=7
edit



use global1, clear
gen id=_n
gen max=_N
gen diff = id[_n] + id[_n+1]    /* using Explicit subscripts with variables  */
edit


* missing values
use kgss2012, clear /* Korean General Social Survey 2014 */
tab1 VOTE12 VOTE121
tab1 VOTE12 VOTE121, nolabel

replace VOTE12 =.  if VOTE12 ==8 | VOTE12==9
tab1 VOTE12, nol


* Summary Statistics

use kgss2012, clear /* Korean General Social Survey 2014 */

tab1 VOTE121, nol
mvdecode VOTE121, mv(77=.\ 88=. \ 99=.)
tab1 VOTE121, nol

tab1 KRPROUD HELPFUL FAIR, nol
mvdecode KRPROUD HELPFUL FAIR, mv(8=.)
tab1 KRPROUD HELPFUL FAIR, nol



use kgss2012, clear
mvdecode  INCOM0, mv(8888=.)
summarize INCOM0
summarize INCOM0, detail
su        INCOM0, d

tabstat   INCOM0, stats(mean sd p5 p95)


tab HAPINSS1

tabstat   INCOM0, stats(mean sd p5 p95) by(HAPINSS1)

























