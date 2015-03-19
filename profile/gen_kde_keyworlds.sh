KDE_EBUILD_PATH=/usr/portage/official/kde-base

for aa in `ls -1 $KDE_EBUILD_PATH`;do
	echo kde-base/$aa
done|grep -v metadata.xml|tee package.keywords/kde.keywords
