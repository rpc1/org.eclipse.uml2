#!/bin/sh

# BEGIN CUSTOMIZATIONS

# The plugin name
pluginName="org.eclipse.uml2"; 

# string labels for javadoc content
windowTitle="UML2 Javadoc";
groupTitle="Unified Modeling Language 2.x";

# files to exclude from javadoc process - use Ant syntax
javadocExclusions="<exclude name=\"**/impl/**\"/> <exclude name=\"**/internal/**\"/> <exclude name=\"**/examples/**\"/> <exclude name=\"**/tests/**\"/> <exclude name=\"**/templates/**\"/>";

# END CUSTOMIZATIONS

##########################################################################

debug=1; if [ $debug -gt 0 ]; then echo "[antJd] debug: "$debug; fi

if [ "x"$ANT_HOME = "x" ]; then export ANT_HOME=/opt/apache-ant-1.6; fi
if [ "x"$JAVA_HOME = "x" ]; then export JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home; fi
export PATH=${PATH}:${ANT_HOME}/bin

# current directory - all but the name of this script, no trailing slash
currentPath=$PWD"/"$0; currentPath=${currentPath%/*}; if [ $debug -gt 0 ]; then echo "[antJd] currentPath: "$currentPath; fi

# path to $buildID/eclipse/plugins, no trailing slash
pluginPath=${currentPath%/$pluginName*}; if [ $debug -gt 0 ]; then echo "[antJd] pluginName: "$pluginName; echo "[antJd] pluginPath: "$pluginPath; fi

# ant script to create and then execute
antScript=$currentPath"/javadoc.xml"; if [ $debug -gt 0 ]; then echo "[antJd] antScript: "$antScript; fi
cp $antScript.template $antScript.template.orig;

# The eclipse directory
eclipseDir=`cd $1; echo $PWD`; if [ $debug -gt 0 ]; then echo "[antJd] eclipseDir: "$eclipseDir; fi

# The destination directory
destDir=$currentPath/../references/javadoc; mkdir -p $destDir; destDir=`cd $destDir; echo $PWD`; # resolve relative path
if [ $debug -gt 0 ]; then echo "[antJd] destDir: "$destDir; fi

hasToken=`grep -c "@plugin@" $antScript".template"`;

# Finds plugins in the Workspace:
pluginDirs=`find $pluginPath -name "${pluginName}*" -maxdepth 1 -type d -print | sort -n | cut -f2 -d' '`; 

if [ $hasToken -gt 0  ]; then
	for pluginDir in $pluginDirs; do
		srcDir=$pluginDir/src; 
		echo "[antJd] Process "$srcDir;
		if [ -d "$srcDir" ]; then
			if [ `find $srcDir -name "*.java" | grep -c .` -eq 0 ]; then # must unpack zips first
				if [ $debug -gt 0 ]; then echo "[antJd] Unpacking *src.zip"; fi
				cp -r ${srcDir} ${srcDir}_orig;
				for f in `find ${srcDir} -name "*src.zip"`; do 
					if [ $debug -gt 1 ]; then echo "[antJd] Unpack $f"; fi
					unzip -q -d $srcDir $f; 
				done
			fi
			if [ $debug -gt 0 ]; then echo "[antJd] *.java in srcDir: "; echo "-----------------"; echo `find $srcDir -type f -name '*.java'`; echo "-----------------"; fi
			packages=`find $srcDir -type f -name '*.java' -exec grep -e '^package .*;' {} \; | sed -e 's/^package *\(.*\);/\1/' | sed -e 's/[ ]*//g' | dos2unix | sort | uniq | xargs | sed -e 's/ /:/g'`;
			if [ $debug -gt 1 ]; then echo "[antJd] packages1: "$packages; fi
			packages=`echo $packages | sed -e 's/\//\\\\\\//g' | sed -e 's/\./\\\\\./g'`; # slash escape
			if [ $debug -gt 1 ]; then echo "[antJd] packages2: "$packages; fi
			sed -e "s/\@plugin\@/${packages}/g" $antScript.template > $antScript.template.tmp;
			mv $antScript.template.tmp $antScript.template;
		fi
	done
#else 
#	echo "[antJd] ERROR! "$currentPath"/javadoc.xml.template does not contain token @plugin@!";
#	exit 1;
fi

# Finds plugins in the Workspace:
pluginDirs=`find $pluginPath -name "${pluginName}*" -maxdepth 1 -type d -print | sort -n | cut -f2 -d' '`; 
if [ $debug -gt 0 ]; then 
	echo "[antJd] pluginDirs:"; 
	for pluginDir in $pluginDirs; do echo "[antJd]   "$pluginDir; done
fi

### TODO?: missing emf/sdo/xsd plugins in $eclipseDir - need to copy them over or reference source so that all classes/packages (and thus @links) can be resolved

# All the jars in the plugins directory
classpath="."`find $eclipseDir/plugins -name "*.jar" -print | sed -e 's/^/:/' -e 's/\n//g'`; if [ $debug -gt 0 ]; then echo "[antJd] classpath: "$classpath; fi

# Calculates the packagesets and the calls to copyDocFiles
packagesets="";
copydocfiles="";
for pluginDir in $pluginDirs; do
	pluginDir=`echo $pluginDir | sed -e 's/\/runtime$//g'`;
	srcDir=$pluginDir/src;
	if [ $debug -gt 0 ]; then echo "[antJd] srcDir: "$srcDir; fi
	if [ -d "$srcDir" ]; then
		# define what to include when javadoc'ing here:
		packagesets=$packagesets"<packageset dir=\"$srcDir\"> ";
		packagesets=$packagesets"<exclude name=\"$srcDir/**/doc-files/**\"/> ";
		packagesets=$packagesets""$javadocExclusions;
		packagesets=$packagesets"</packageset>";
		copydocfiles=$copydocfiles"<copyDocFiles pluginDir=\"$pluginDir\"/>";
	fi
done
if [ $debug -gt 0 ]; then 
	echo "[antJd] packagesets:";	echo $packagesets;
	echo "[antJd] copydocfiles:";	echo $copydocfiles;
fi
	
# Finds the proper org.eclipse.platform.doc.isv jar
docjar=`find $eclipseDir/plugins/ -name "org.eclipse.platform.doc.isv*.jar" -print`; if [ $debug -gt 1 ]; then echo "[antJd] docjar: "$docjar; fi

# do replacements in template
if [ $debug -gt 1 ]; then echo "[antJd] Replace @packagesets@ in the template ..."; fi
packagesets=`echo $packagesets | sed -e 's/\//\\\\\\//g' | sed -e 's/\./\\\\\./g'`;
sed -e "s/\@packagesets\@/${packagesets}/g" $antScript.template > $antScript.template.tmp;

if [ $debug -gt 1 ]; then echo "[antJd] Replace @copydocfiles@ in the template ..."; fi
copydocfiles=`echo $copydocfiles | sed -e 's/\//\\\\\\//g' | sed -e 's/\./\\\\\./g'`;
sed -e "s/\@copydocfiles\@/${copydocfiles}/g" $antScript.template.tmp > $antScript;

#run ant to do javadoc build
ant -f $antScript \
	-DdestDir="$destDir" \
	-Dclasspath="$classpath" \
	-DeclipseDir="$eclipseDir" \
	-Ddocjar="$docjar" \
	-DwindowTitle="$windowTitle" \
	-DgroupTitle="$groupTitle" \
	-Doverview="$currentPath/overview.html";

# Clean up templates
rm -f $antScript $antScript.template.tmp;
mv -f $antScript.template.orig $antScript.template;

# Generate topics_Reference.xml (replacement for doclet). 
trXML=$currentPath"/../topics_Reference.xml";
echo '<?xml version="1.0" encoding="UTF-8"?>' > $trXML;
echo '<?NLS TYPE="org.eclipse.help.toc"?>' >> $trXML;
echo '<toc label="Reference">' >> $trXML;
echo '  <topic label="API Reference" href="references/javadoc/overview-summary.html">' >> $trXML;
for packSum in `find $destDir -name "package-summary.html" | sort`; do
	path=${packSum%/package-summary.html}; path=${path#$destDir/}; # org/eclipse/xsd/ecore/importer/taskdefs
	label=${path//\//.}; # org.eclipse.xsd.ecore.importer.taskdefs
	echo '    <topic label="'$label'" href="references/javadoc/'$path'/package-summary.html" />' >> $trXML;
done
echo '  </topic>' >> $trXML;
echo '</toc>' >> $trXML;

# cleanup unpacked src/ folders
for pluginDir in $pluginDirs; do
	srcDir=$pluginDir/src; 
	if [[ -d ${srcDir}"_orig" ]]; then
		echo "[antJd] Replace unpacked "$srcDir;
		rm -fr ${srcDir}; # clean up unpacked source
		mv -f ${srcDir}_orig ${srcDir};
	fi
done
