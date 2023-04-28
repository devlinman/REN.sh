# REN.sh
__Renames bad file extensions, Converts images, Compresses folders__

__A companion script for KDE connect.__

---

## Purpose

- I transfer *a lot* of files between my devices.

- When I transfer files from my phone to my computer, some files do not have proper extensions.

- Now, originally, this script just renamed files to their proper extensions. But a few more functionalities were added. And there are a few more ideas.

- If you just run `REN`, [ it will run (only) on the current directory ] all the files with improper extensions will be renamed to proper ones.
  
  Under the hood, it uses the following command to determine the file/mime type:

`$ file -b --mime-type "$file"`

- Currently, this script can properly rename the following file/mime types:
	1. WEBP    -   (image/webp)
	2. PNG     -   (image/png)
	3. JPEG    -   (image/jpeg)
	4. HEIC    -   (image/heic)
	5. MP4     -   (video/mp4)
	6. MKV     -   (video/x-matroska)
	7. MOV     -   (video/quicktime)
	8. MP3     -   (audio/mpeg)
	9. DOCX    -   (application/vnd.openxmlformats-officedocument.wordprocessingml.document)
	10. PDF    -   (application/pdf)


- Support for more formats is underway. But these are the most commonly used file types.

- A file named `foo.bar.ext.png` which is of file type `image/jpeg` will be renamed to `foo.bar.ext.jpg`.


- **Additional functionalities include:**

	- If the name of the current folder is `foo`, `REN -x` converts all '**png**' and '**webp**' files into '**jpg**', and places all files in the current directory into a new folder with the name `foo.zipper` in current directory [ other files will be copied as they are ].
	- `REN -xzip` will create a **PASSWORD-PROTECTED ZIP file** from the folder `foo.zipper` [ in the parent directory alongside the current directory - `foo` ], and promptly removes the folder `foo.zipper`.  
	  
	  **I regularly use `REN -xzip` to transfer archives to my iPad and `REN -x` to transfer images to Android devices.**

	- `REN -l /path/to/folder` [ works on current directory if no path is specified ] will list all files in the specified path and their corresponding file/mime types.
	- **I added colors!!**

---

## How to use it?

### Install:
- There is a make file in this directory. Use the following command to install this app.

`$ sudo make install`

### Uninstall:
- Again, use the same make file to uninstall (Recommended):

`$ sudo make remove`

- Alternatively, run this command (Not Recommended):

`$ sudo rm /usr/bin/REN`

### Display Help:

- Just use `REN -h` or `REN --help` to see help info.
 
---

## Licensing
- I don't care what you do with this.
- But it would be *kewl* if you mention me.

---

## Contribution
- Do let me know if there is some edge case(s).
- Any forks and merge requests are accepted.


***

Authored by:	**@_devlinman**

***
### P.S.
Use JetBrains Mono!
> =>	~~>
