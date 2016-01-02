#!/usr/bin/env python

# <a href="===INSERT_THEME_SWITCH_HERE===">Switch to ===SWAP_THEME_NAME===</a>

#!/usr/bin/python

import os

def process_file( dirName, fname, fileIs='' ):
    htmlFile = os.path.join( dirName, fname )
    # print dirName, fname
    contents=open(htmlFile,'r').read()
    rootOfPath = '/'.join( dirName.split(os.path.sep)[1:] )
    # print rootOfPath
    newContents=''
    replacedFields=[]
    if 'light' in rootOfPath or fileIs=='light':
        if fileIs=='light':
            newPath='dark'
        else:
            newPath = rootOfPath.replace('light','dark')
        newContents=contents.replace('===INSERT_THEME_SWITCH_HERE===', '/%s' % newPath )
        replacedThemeName='Join the %s side!' % 'dark'
        newContents=newContents.replace('===SWAP_THEME_NAME===', replacedThemeName )
        replacedFields.append( newPath )
        replacedFields.append( replacedThemeName )
        open(htmlFile,'w').write( newContents)
    elif 'dark' in rootOfPath or fileIs=='dark':
        newPath = rootOfPath.replace('dark','light')
        newContents=contents.replace('===INSERT_THEME_SWITCH_HERE===', '/%s' % newPath )
        replacedThemeName='Join the %s side!' % 'light'
        newContents=newContents.replace('===SWAP_THEME_NAME===', replacedThemeName )
        replacedFields.append( newPath )
        replacedFields.append( replacedThemeName )
        open(htmlFile,'w').write( newContents)
    if newContents:
        print 'Mangled %s: %s.' % ( htmlFile, replacedFields )
        # print newContents
    return

def embed_switch_URLs( aDir, processList ):

 rootDir = aDir
 for dirName, subdirList, fileList in os.walk(rootDir):
         for fname in fileList:
             ext=fname.split('.')[-1]
             if ext in processList:
                 process_file( dirName, fname )


processList = ('html',)
# Cover the majority of the site
embed_switch_URLs( '_site', processList)

# Handle single-file edge case
process_file( '_site', 'index.html', 'light' )

