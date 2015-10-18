(cd /usr/portage/official/;find dev-qt kde-base kde-apps -maxdepth 1 -mindepth 1 -type d|sed -e "s/^/<=/" -e "s/$/-5/") \
|tee package.keywords/kde.keywords

