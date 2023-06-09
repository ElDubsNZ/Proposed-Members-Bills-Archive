# Proposed Members' Bills Archive

When a Member of Parliament wants to propose a bill to be considered by Parliament, there are two avenues for this. One is if they are a member of the government, it can be submitted as a "government bill", members make bids to have their bill included in the government's bills.

The other way, is a Private Members' Bill, where their bill goes into a ballot. If drawn, it is considered by Parliament.

Before it is drawn however, it is not at all considered Official Parliamentary Business. It is only held on Parliament's website to be informative. If an MP withdraws their bill, then Parliament deletes the content from the website.

In an effort to retain this information, this script was developed to regularly update the content to the Wayback Machine.

It backs up twice a day, just in case anything is missed on one of the runs. Once at noon, and once at midnight.

All the backups from before 2023-03-03 can be viewed at these four links:  
[Proposed Members' Bills - Page 1](https://web.archive.org/web/20221101000000*/https://www.parliament.nz/en/pb/bills-and-laws/proposed-members-bills/?page=1)  
[Proposed Members' Bills - Page 2](https://web.archive.org/web/20221101000000*/https://www.parliament.nz/en/pb/bills-and-laws/proposed-members-bills/?page=2)  
[Proposed Members' Bills - Page 3](https://web.archive.org/web/20221101000000*/https://www.parliament.nz/en/pb/bills-and-laws/proposed-members-bills/?page=3)  
[Proposed Members' Bills - Page 4](https://web.archive.org/web/20221101000000*/https://www.parliament.nz/en/pb/bills-and-laws/proposed-members-bills/?page=4)

This is because the proposed bills were split into pages of 20 each, so with often 60+ bills, it took up four pages, and there was no "View all" link.

There was a down period of a couple weeks before I noted that the website was updated and I had to rebuild the code. As of 2023-03-15, the lists look like this:  
[Proposed Members' Bills](https://web.archive.org/web/20230000000000*/https://bills.parliament.nz/proposed-members-bills)

Unfortunately, there is no longer a way to "click through" the pages, as this is not collected by the archive. I will be working to create an alternative system.

A twice-daily crontab is running to keep this up to date. As well as this, an hourly check for any changes occurs, and if a change is found, an additional backup to Internet Archive Occurs.

I've created a wordpress blog to present changes, though I am looking for a better solution:
https://proposedbills.wordpress.com/

I have yet to discover a better way to present this information, but have been considering linking in with Wikidata, which could structure the information much better and also track changes to the bill's metadata.

##spn.sh

To do the actual archiving, we make use of overcast07's [Wayback Machine SPN Scripts](https://github.com/overcast07/wayback-machine-spn-scripts).

This is capable of running through the bills.txt and pdfs.txt files to archive every URL contained in them.
