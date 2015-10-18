
#(cd /usr/portage/official/;find dev-qt kde-frameworks kde-plasma kde-apps -maxdepth 1 -mindepth 1 -type d|sed "s/$/:5/") \
(cd /usr/portage/official/;find dev-qt kde-frameworks kde-plasma kde-apps -maxdepth 1 -mindepth 1 -type d|sed -e "s/^/>=/" -e "s/$/-5/") \
|tee package.keywords/kde-frameworks.keywords
