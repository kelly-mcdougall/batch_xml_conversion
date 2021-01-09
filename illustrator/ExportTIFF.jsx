/**********************************************************
Save as PDFs.js
DESCRIPTION
This sample gets files specified by the user from the
selected folder and batch processes them and saves them
as PDFs in the user desired destination with the same
file name.
 **********************************************************/
app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;
var folder, files, sourceDoc, targetFile, tifExportOpts;
// Select the source folder.
folder = Folder.selectDialog('Select the folder with eps files you want to convert to TIF', '~');

// If folder variable return null, user most likely canceled the dialog or
// the input folder and it subfolders don't contain any .ai files.
if (folder != null) {
    // returns an array of file paths in the selected folder.
    files = GetFiles(folder);
    // This is where things actually start happening...
    process(files);
}


function GetFiles(folder) {
    
    var i, item,
    // Array to store the files in...
    files =[],
    // Get files...
    items = folder.getFiles();
    
    // Loop through all files in the given folder
    for (i = 0; i < items.length; i++) {
        
        item = items[i];
        
        // Find .eps files
        var fileformat = item.name.match(/\.eps$/i),
        legacyFile = item.name.indexOf("(legacyFile)") > 0;
        
        // If item is a folder, check the folder for files.
        if (item instanceof Folder) {
            
            // Combine existing array with files found in the folder
            files = files.concat(GetFiles(item));
        }
        // If the item is a file, push it to the array.
        else if (item instanceof File && fileformat && ! legacyFile) {
            
            // Push files to the array
            files.push(item);
        }
    }
    
    return files;
}



function process(files) {
    if (files.length > 0) {
        
        for (i = 0; i < files.length; i++) {
            sourceDoc = app.open(files[i]);
            targetFile = files[i].toString().replace('.eps', ".tif");
            // Call function getPNGOptions get the PNGExportOptions for the files
            tifExportOpts = getTIFOptions();
            // Export as TIF
            sourceDoc.exportFile(new File(targetFile), ExportType.TIFF, tifExportOpts);
            sourceDoc.close(SaveOptions.DONOTSAVECHANGES);
        }
        alert('Conversion complete');
    } else {
        alert('No matching files found');
    }
}


function getTIFOptions() {
    var tifExportOpts = new ExportOptionsTIFF();
    return tifExportOpts;
}
