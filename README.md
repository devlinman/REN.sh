# REN.sh
__Renames bad file extensions, Converts images, Creates PDFs, Compresses folders__

__A companion script for KDE connect.__

---

## Purpose

- I transfer *a lot* of files between my devices.

- When I transfer files from my phone to my computer, some files do not have proper extensions. 
- Just running `REN [/path/to/directory]` (If no path is specified, it runs in the present working directory) will fix all files with wrong extensions in that directory. 

- Currently, this script can properly rename the following file/mime types:  

              File type                  ->    Extension
              
        	1. WEBP (image/webp)         ->    .webp
        	2. PNG (image/png)           ->    .png
        	3. JPEG (image/jpeg)         ->    .jpg
        	4. HEIC (image/heic)         ->    .heic
        	5. MP4 (video/mp4)           ->    .mp4
        	6. MKV (video/x-matroska)    ->    .mkv
        	7. MOV (video/quicktime)     ->    .mov
        	8. MP3 (audio/mpeg)          ->    .mp3
        	9. DOCX (* WORD DOCUMENT)    ->    .docx
        	10. PDF (application/pdf)    ->    .pdf
        	
        * mime type of word documents: application/vnd.openxmlformats-officedocument.wordprocessingml.document

- Support for more formats is underway. But these are the most commonly used file types.

- A file named `foo.bar.ext.png` which is of file type `image/jpeg` will be renamed to `foo.bar.ext.jpg`.

- Originally, this script just renamed files to their proper extensions. But a few more functionalities were added.

- **Additional functionalities include:**

	- **I added colors!!**
	- If the name of the current folder is `foo`, `REN -x` converts all '**png**' and '**webp**' files into '**jpg**' files (Using ImageMagick - convert), and places *all files in the current directory* in a *new folder in current directory* with the name `foo.zipper`  (other files will be copied as they are).
	
    - `REN -xpdf` will create a **PDF** file from all the images in the folder `foo.zipper` and promptly removes the folder `foo.zipper`

	- `REN -xzip` will create a **PASSWORD-PROTECTED ZIP file** (Using `zip -re`) from the folder `foo.zipper` (in the parent directory alongside the current directory - `foo`), and promptly removes the folder `foo.zipper`.  

    - Both `-xpdf` and `-xzip` are extensions of `REN -x`. Currently, all three options - `-x`, `-xpdf`, `-xzip` only run in the current directory - path to a directory cannot be specified with these three options.

	  **I regularly use `REN -xzip` to transfer archives to my iPad and `REN -xpdf` to transfer images to Android devices.**


	- `REN -l [/path/to/folder]` (works on current directory if no path is specified) will list all files in the specified path and their corresponding file/mime types. Useful for analysis & debugging.
	- `REN -h` or `REN --help` will display help info and exit.

---

## How to use it?

### Install:
- There is a make file in this directory. Use the following command to install this app.

`$ sudo make install`

#### Dependencies:
- file
- zip
- convert (ImageMagick)

The Makefile will check if all dependencies are satisfied.
### Uninstall:
- Again, use the same make file to uninstall (Recommended):

`$ sudo make remove`

- Alternatively, run this command (Not Recommended):

`$ sudo rm /usr/bin/REN`

### Display Help:

- Just use `REN -h` or `REN --help` to see help info.

### Rename files to their proper extensions:
- `REN [/path/to/directory]` will rename all files to their proper extensions.
- For example, if `$file` is set to `example.jpg.txt`, and it is a PNG file, then `${file##.}` will remove the longest match of `*.` from the beginning of the string. The file will be renamed to `example.jpg.png`. If you want, you can change this to `${file#.}` - to rename `example.jpg.txt` as `example.png` (line 115, 116 in [REN.sh](./REN.sh))

### List mime types of all files in a directory:
- `REN -l [/path/to/directory]` will list all files and their corresponding mime types.
- Under the hood, it uses the following command to determine the file/mime type:  
  
    `$ file -b --mime-type "$file"`

### Convert PNG and WEBP files to JPGs:
- `REN -x` creates a folder ${PWD}.zipper (where $PWD is present working directory) alongside the current directory.

### Convert a folder full of images (PNG, WEBP and JPG) into PDF:
- `REN -xpdf` will create a folder named 'PDF' alongside the current working directory.

### Convert a folder into a Password-protected zip file:
- `Ren -xzip` will create a zip file alongside the current working directory. You will be prompted to enter (and verify) your password in the terminal.
 
### Copyright Notices:
- Use `REN -c` to view copyright notice.
---

## Licensing
- I don't care what you do with this.
- But it would be *kewl* if you mention me.
- Check the [LICENSE](./LICENSE) file.

---

## Contribution
- Do let me know if there is some edge case(s).
- Any forks and merge requests are accepted.


***

Authored by:	**@_devlinman**

***
### P.S.
Tip to find mime types easily:
> alias mime="file -b --mime-type"

Use JetBrains Mono!
> =>	~~>
