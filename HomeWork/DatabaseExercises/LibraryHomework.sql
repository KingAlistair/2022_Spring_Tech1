    # 1.  Show the members under the name "Jens S." who were born before 1970 that became members of the library in 2013.
        SELECT * FROM tmember WHERE cName = 'Jens S.' AND dBirth < '1970-01-01' AND dNewMember LIKE '2013%';

    # 2.   Show those books that have not been published by the publishing companies with ID 15 and 32, except if they were published before 2000.
        SELECT * FROM tbook WHERE nPublishingCompanyID NOT IN (15, 32) OR nPublishingYear < '2000-01-01';

    # 3.   Show the name and surname of the members who have a phone number, but no address.
        SELECT cName, cSurname FROM tmember WHERE cPhoneNo IS NOT NULL AND cAddress IS NULL;

    # 4.   Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S" (uppercase).
        SELECT * FROM tauthor WHERE cSurname = 'Byatt' AND cName LIKE 'A%' AND cName LIKE '%S%';

    # 5.	Show the number of books published in 2007 by the publishing company with ID 32.
        SELECT COUNT(*) FROM tbook WHERE nPublishingYear = 2007 AND nPublishingCompanyID = 32;

    # 6.	For each day of the year 2014, show the number of books loaned by the member with CPR "0305393207";
        SELECT COUNT(*) FROM tloan WHERE cCPR = '0305393207' AND dLoan LIKE '2014%';

    #7.	    Modify the previous clause so that only those days where the member was loaned more than one book appear.
        SELECT dLoan FROM tloan WHERE cCPR = '0305393207' AND dLoan LIKE '2014%' GROUP BY dLoan HAVING count(*) > 1;

    #8.	Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
        SELECT * FROM tmember ORDER BY dNewMember DESC, cSurname,cName;

    #9.	Show the title of all books published  the publishing company with ID 32 along with their theme or themes.
        SELECT cTitle, cName FROM tbook, tbooktheme, ttheme WHERE nPublishingCompanyID = 32
        AND tbook.nBookID = tbooktheme.nBookID AND tbooktheme.nThemeID = ttheme.nThemeID;

    #10. Show the name and surname of every author along with the number of books authored by them, but only for authors who have registered books on the database.
        SELECT cName, cSurname, COUNT(*) FROM tauthor, tbook, tauthorship WHERE tauthor.nAuthorID = tauthorship.nAuthorID
        AND tauthorship.nBookID = tbook.nBookID AND cTitle IS NOT NULL GROUP BY cNAme;

    #11. Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
        SELECT cName, cSurname, MIN(nPublishingYear) AS MinimumYear FROM tauthor, tauthorship, tbook
        WHERE tauthor.nAuthorID = tauthorship.nAuthorID AND tauthorship.nBookID = tbook.nBookID AND cTitle IS NOT NULL group by cName;

    #12. For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.
        SELECT tloan.cSignature, dLoan, cTitle, cName, cSurname FROM tloan, tbookcopy, tbook, tmember
        WHERE tloan.cSignature = tbookcopy.cSignature AND tbookcopy.nBookID = tbook.nBookID AND tloan.cCPR = tmember.cCPR;

    #13. Repeat exercises 9 to 12 using the modern JOIN notation.

        #13.9
        SELECT cTitle, cName FROM tbook
        INNER JOIN tbooktheme ON tbook.nBookID = tbooktheme.nBookID
        INNER JOIN ttheme ON tbooktheme.nThemeID = ttheme.nThemeID
        WHERE nPublishingCompanyID = 32;

        #13.10
        SELECT cName, cSurname, COUNT(*) FROM tauthor
        INNER JOIN tauthorship t ON tauthor.nAuthorID = t.nAuthorID
        INNER JOIN tbook t2 ON t.nBookID = t2.nBookID
        WHERE cTitle IS NOT NULL GROUP BY cName, cSurname;

        #13.11
        SELECT cName, cSurname, MIN(nPublishingYear) AS MinimumYear FROM tauthor
        INNER JOIN tauthorship t ON tauthor.nAuthorID = t.nAuthorID
        INNER JOIN tbook t2 ON t.nBookID = t2.nBookID
        WHERE cTitle IS NOT  NULL GROUP BY cName;

        #13.12
        SELECT tloan.cSignature, dLoan, cTitle, cName, cSurname FROM tloan
        INNER JOIN tbookcopy t ON tloan.cSignature = t.cSignature
        INNER JOIN tbook t2 ON t.nBookID = t2.nBookID
        INNER JOIN tmember t3 ON tloan.cCPR = t3.cCPR;

    #14. Show all theme names along with the titles of their associated books. All themes must appear (even if there are no books for some particular themes). Sort by theme name.
        SELECT cName, cTitle FROM ttheme
        LEFT JOIN tbooktheme ON ttheme.nThemeID = tbooktheme.nThemeID
        LEFT JOIN tbook ON tbooktheme.nBookID = tbook.nBookID
        ORDER BY cName;

    #15. Show the name and surname of all members who joined the library in 2013 along with the title of the books they took on loan during that same year. All members must be shown, even if they did not take any book on loan during 2013. Sort by member surname and name.
        SELECT tmember.cName, tmember.cSurname, if(dLoan LIKE '2013%', tbook.cTitle, '') AS BookRentedIn2013  FROM tmember
        LEFT JOIN tloan ON tmember.cCPR = tloan.cCPR
        LEFT JOIN tbookcopy ON tloan.cSignature = tbookcopy.cSignature
        LEFT JOIN tbook ON tbookcopy.nBookID = tbook.nBookID
        WHERE tmember.dNewMember LIKE '2013%' GROUP BY cName,cSurname ORDER BY cName, cSurname;

    #16. Show the name and surname of all authors along with their nationality or nationalities and the titles of their books. Every author must be shown, even though s/he has no registered books. Sort by author name and surname.
        SELECT tauthor.cName, tauthor.cSurname,tcountry.cName, tbook.cTitle  FROM tauthor
        LEFT JOIN tnationality ON tauthor.nAuthorID = tnationality.nAuthorID
        LEFT JOIN tcountry ON tnationality.nCountryID = tcountry.nCountryID
        LEFT JOIN tauthorship ON tauthor.nAuthorID = tauthorship.nAuthorID
        LEFT JOIN tbook ON tauthorship.nBookID = tbook.nBookID
        ORDER BY tauthor.cName, tauthor.cSurname;

    #17. Show the title of those books which have had different editions published in both 1970 and 1989.
        SELECT cTitle FROM tbook WHERE nPublishingYear = 1970 OR nPublishingYear = 1989
        GROUP BY cTitle HAVING COUNT(*) > 1;

    #18. Show the surname and name of all members who joined the library in December 2013 followed by the surname and name of those authors whose name is “William”.
        SELECT tmember.cSurname, tmember.cName, tauthor.cSurname, tauthor.cName FROM tmember, tauthor
        WHERE dNewMember LIKE '2013-12%' AND tauthor.cName = 'William';

    # 19.	Show the name and surname of the first chronological member of the library using subqueries.
        SELECT cName, cSurname FROM tmember WHERE dNewMember = (SELECT dNewMember FROM tmember ORDER BY dNewMember LIMIT 1);

    # 20.	For each publishing year, show the number of book titles published by publishing companies from countries
    # that constitute the nationality for at least three authors. Use subqueries.
        SELECT tbook.nPublishingYear, COUNT(cTitle) FROM tbook,
        (SELECT cName FROM tcountry LEFT JOIN tnationality ON tcountry.nCountryID = tnationality.nCountryID
            GROUP BY cName HAVING COUNT(cName)>=3) name;
            
        #Got confused by this one couldn't finish it.

    # 21.	Show the name and country of all publishing companies with the headings "Name" and "Country".
        SELECT tpublishingcompany.cName AS Name, tcountry.cName AS Country FROM tpublishingcompany
        INNER JOIN tcountry ON tpublishingcompany.nCountryID = tcountry.nCountryID;

    # 22.	Show the titles of the books published between 1926 and 1978 that were not published by the publishing company with ID 32.
        SELECT cTitle FROM tbook WHERE nPublishingYear >= 1926 AND nPublishingYear <=1978 AND NOT nPublishingCompanyID = 32;

    # 23.	Show the name and surname of the members who joined the library after 2016 and have no address.
        SELECT cName, cSurname FROM tmember WHERE dNewMember >= '2016-01-01' AND cAddress IS NULL;

    #  24.	Show the country codes for countries with publishing companies. Exclude repeated values.
        SELECT DISTINCT nCountryID FROM tpublishingcompany WHERE tpublishingcompany.cName IS NOT NULL;

    # 25.	Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
        SELECT cTitle FROM tbook
        INNER JOIN tpublishingcompany ON tbook.nPublishingCompanyID = tpublishingcompany.nPublishingCompanyID
        WHERE cTitle LIKE 'The Tale%' AND NOT cName = 'Lynch Inc';

    # 26.	Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.
        SELECT DISTINCT ttheme.cName FROM ttheme
        INNER JOIN tbooktheme ON ttheme.nThemeID = tbooktheme.nThemeID
        INNER JOIN tbook ON tbooktheme.nBookID = tbook.nBookID
        INNER JOIN tpublishingcompany ON tbook.nPublishingCompanyID = tpublishingcompany.nPublishingCompanyID
        WHERE tpublishingcompany.cName = 'Lynch Inc';

    # 27.	Show the titles of those books which have never been loaned.
        SELECT * FROM tbook
        INNER JOIN tbookcopy ON tbook.nBookID = tbookcopy.nBookID
        INNER JOIN tloan ON tbookcopy.cSignature = tloan.cSignature
        WHERE tloan.dLoan IS NULL;

    # 28.	For each publishing company, show its number of existing books under the heading "No. of Books".
        SELECT tpublishingcompany.cName, COUNT(cTitle) AS 'No. of Books' FROM tpublishingcompany
        INNER JOIN tbook ON tpublishingcompany.nPublishingCompanyID = tbook.nPublishingCompanyID GROUP BY tpublishingcompany.cName;

    # 29.	Show the number of members who took some book on a loan during 2013.
        SELECT COUNT(DISTINCT tmember.cName) AS 'No. of members loaning' FROM tmember
        INNER JOIN tloan ON tmember.cCPR = tloan.cCPR
        WHERE tloan.dLoan LIKE '2013%';

    # 30.	For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".
        SELECT tbook.cTitle, COUNT(tauthor.cName) AS "No. of Authors" FROM tbook
        INNER JOIN tauthorship ON tbook.nBookID = tauthorship.nBookID
        INNER JOIN tauthor ON tauthorship.nAuthorID = tauthor.nAuthorID
        GROUP BY tbook.cTitle HAVING COUNT(*) > 1;
