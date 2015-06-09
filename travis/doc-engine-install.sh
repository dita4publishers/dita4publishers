#!/bin/bash
set -e # exit with nonzero exit code if anything fails

OUTDIR=OUT

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR=${PWD} 
D4P_DIR=$SCRIPT_DIR/dita4publishers
HOME_DIR="$(dirname "$TRAVIS_BUILD_DIR")"
DOC_DIR=$(basename "$GH_REF")

export DITA_REPO=http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Stable%20Release/DITA%20Open%20Toolkit%201.8/DITA-OT1.8.5_full_easy_install_bin.tar.gz/download
export DOC_ENGINE_DIR=$SCRIPT_DIR
export ANT_OPTS=-Xmx2048m
export DITA_DIR=DITA-OT1.8.5
export CLASSPATH=$DITA_DIR/lib/:$DITA_DIR/lib/dost.jar:$DITA_DIR/lib/commons-codec-1.4.jar:$DITA_DIR/lib/resolver.jar:lib/icu4j.jar:$DITA_DIR/lib/xercesImpl.jar:$DITA_DIR/lib/xml-apis.jar:$DITA_DIR/lib/saxon/saxon9.jar:$DITA_DIR/lib/saxon/saxon9-dom.jar
export ANT_HOME=$DITA_DIR/tools/ant PATH=$DITA_DIR/tools/ant/bin:$PATH

echo -e "${YELLOW}Variables${NC}"
echo "\$HOME_DIR: $HOME_DIR"
echo "\$DOC_DIR: $DOC_DIR"
echo "\$SCRIPT_DIR: $SCRIPT_DIR"
echo "\$D4P_DIR: $D4P_DIR"
echo "\$OUTDIR: $OUTDIR"
echo "\$DITA_REPO: $DITA_REPO"

echo -e "${YELLOW}Environement Variables${NC}"
echo "\$ANT_OPTS: $ANT_OPTS"
echo "\$DITA_DIR: $DITA_DIR"
echo "\$CLASSPATH: $CLASSPATH"
echo "\$ANT_HOME: $ANT_HOME"


if [ -z "$BRANCH" ]; 
	then 
	echo -e "${YELLOW}Using branch $BRANCH${NC}"
	cd $TRAVIS_BUILD_DIR
    git checkout $BRANCH
fi

echo -e "${YELLOW}Installing engine${NC}"

cd $D4P_DIR
git submodule update --init --recursive
chmod +x ./travis/travis-before-install.sh
bash ./travis/travis-before-install.sh

echo -e "${YELLOW}Building documentation${NC}"

mkdir $HOME_DIR/$OUTDIR
ant -f ./$DITA_DIR/integrator.xml
ant -f ./$DITA_DIR/build.xml -Dargs.input=$TRAVIS_BUILD_DIR/$DITAMAP -Doutput.dir=$HOME_DIR/$OUTDIR -Dtranstype=$TRANSTYPE

# clone dir
echo -e "${YELLOW}Adding files to gh-pages branch${NC}"
cd 
git clone https://${GH_TOKEN}@${GH_REF}
cd $DOC_DIR
git checkout gh-pages

# copy files
cp -r $HOME_DIR/$OUTDIR/* ./

# inside this git repo we'll pretend to be a new user
git config user.name $GIT_USERNAME
git config user.email $GIT_EMAIL

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
git add -A .
git commit -m "Deploy documention"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
echo -e "${YELLOW}Pushing content${NC}"
git push
