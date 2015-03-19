#!/bin/bash

echo "## Showing useless entries in package.keywords..."
while read line; do 
        # skip empty or commented out lines
        if [[ $(echo $line | grep ^[^\#$]) == "" ]]; then
                continue
        fi
        
        # parse the entry from the file
        category=`echo $line | cut -d" " -f1 | sed -e 's/^[<>=]*//' -e 's/\/.*//'`
        package=`echo $line | cut -d" " -f1 | sed  -e 's/^[<>=]*[a-z]*\-[a-z]*\///' -e 's/\-[0-9].*$//'`
        # parse the output of eix
        installed_version=`eix --format '{installedversions}<installedversions>{else}none{}' -C $category -e $package | head -n 1`
        available_versions=`eix --format '<availableversions>' -C $category -e $package | head -n 1`

        if [[ "$installed_version" == "" ]]; then
                echo "$category/$package: Package does not exist (or a problem occured)"                                                                                                    
                continue
        fi

        if [[ "$installed_version" == "none" ]]; then
                echo "$category/$package: Package is not installed"
                continue
        fi

        if [[ $(echo $available_versions | grep -P "$installed_version(\s|\[)") == "" ]]; then
                echo "$category/$package: $installed_version is no longer in Portage"       
        fi

        if [[ $(echo $available_versions | grep -P "\s$installed_version(\s|\[)") != "" ]]; then
                echo "$category/$package has become stable"
        fi

done < /etc/portage/package.keywords

echo -e "\n## Showing useless entries in package.unmask..."

while read line; do
        if [[ $(echo $line | grep ^[^\#$]) == "" ]]; then
                continue
        fi
        
        category=`echo $line | cut -d" " -f1 | sed -e 's/^[<>=]*//' -e 's/\/.*//'`
        package=`echo $line | cut -d" " -f1 | sed  -e 's/^[<>=]*[a-z]*\-[a-z]*\///' -e 's/\-[0-9].*$//'`
        installed_version=`eix --format '{installedversions}<installedversions>{else}none{}' -C $category -e $package | head -n 1`
        available_versions=`eix --format '<availableversions>' -C $category -e $package | head -n 1`

        if [[ "$installed_version" == "" ]]; then
                echo "$category/$package: Package does not exist (or a problem occured)"
                continue
        fi
        
        if [[ "$installed_version" == "none" ]]; then
                echo "$category/$package: Package is not installed"
                continue
        fi

        if [[ $(echo $available_versions | grep -P "$installed_version(\s|\[)") == "" ]]; then
                echo "$category/$package: $installed_version is no longer in portage"
                continue
        fi
        
        if [[  $(echo $available_versions | grep -P "\[M\]$installed_version(\s|\[)") == "" ]]; then
                echo "$category/$package is no longer masked"                                                               
        fi                                                                                                                  
                                                                                                                            
done < /etc/portage/package.unmask

