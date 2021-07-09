
#(cd /usr/portage/official/;find dev-qt kde-frameworks kde-plasma kde-apps -maxdepth 1 -mindepth 1 -type d|sed "s/$/:5/") \
#(cd /usr/portage/official/;find dev-qt kde-frameworks kde-plasma kde-apps -maxdepth 1 -mindepth 1 -type d|sed -e "s/^/>=/" -e "s/$/-5/") \

#(cd /usr/portage/official/;find dev-qt kde-frameworks kde-plasma kde-apps -maxdepth 1 -mindepth 1 -type d) \
(cd /usr/portage/official/;find kde-misc kde-frameworks kde-plasma kde-apps -maxdepth 1 -mindepth 1 -type d)|sort|tee package.accept_keywords/kde-frameworks.accept_keywords
