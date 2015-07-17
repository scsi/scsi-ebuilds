
(cd /usr/portage/official/;find dev-qt kde-frameworks kde-plasma -maxdepth 1 -mindepth 1|sed "s/$/:5/") \
|tee package.keywords/kde-frameworks.keywords
