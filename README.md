<!-- Author: devlinman -->

# REN.sh

__Renames bad file extensions__

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
        	9. GIF (image/gif)           ->    .gif
        	10. PDF (application/pdf)    ->    .pdf
        	





---

## How to use it?

### Install
- There is a Makefile in this directory. Use the following command to install this app.

- Clone the repo.

- Run `$ sudo make install`.

- App is installed at `/usr/bin/REN`, License is installed at `/usr/share/licenses/REN`.

#### Dependencies
- `file`

- The Makefile will check if all dependencies are satisfied.

### Uninstall
- Again, use the same make file to uninstall (Recommended):

- Run `$ sudo make remove`.

### Display Help

- `REN -h` or `REN --help` will display help info and exit.

### Rename files to their proper extensions

- `REN [/path/to/directory]` will rename all files to their proper extensions. If no path is given, it runs on Current-Working-Directory. 

- **REN.sh is not recursive on sub-folders.**

- A file named `foo.bar.ext.png` which is of file type `image/jpeg` will be renamed to `foo.bar.ext.jpg`.

- If `$file` is set to `example.jpg.txt`, and it is a PNG file, then `${file##.}` will keep the longest match of `*.` from the beginning of the string. The file will be renamed to `example.jpg.png`. 

- If you want, you can change this to `${file#.}` - to rename `example.jpg.txt` as `example.png`. 

### List mime types

- `REN -l [/path/to/folder]` (works on current directory if no path is specified) will list all files in the specified path and their corresponding file/mime types. Useful for analysis & debugging - like a dry-run.
  
- Under the hood, it uses the following command to determine the file/mime type:
    `$ file -b --mime-type "$file"`

---

## Licensing
- I don't care what you do with this.
- But it would be *kewl* if you mention me.
- Check the [LICENSE](./LICENSE) file.

---

## Contribution
- Do let me know if there is some edge case(s).


--- 
### P.S.
- Tip to find mime types easily:

 `alias mime="file -b --mime-type"`

- Use JetBrains Mono!

> => ~~>
