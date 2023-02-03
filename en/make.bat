@echo off
echo Starting lernOS Guide Generation ...

REM Variables
set filename="lernOS-Zettelkasten-Guide-en"
set chapters=./src/index.md ./src/1-1-Lebenslanges-Lernen-und-Wissensarbeit.md ./src/1-2-lernOS-Canvas.md ./src/1-3-lernOS-Flow.md ./src/1-4-lernOS-Workplace.md ./src/1-5-lernOS-Memex.md ./src/2-0-PKM-Grundlagen.md ./src/2-0-Lernpfad-Ueberblick.md ./src/2-1-Kata-0.md ./src/2-1-Kata-1.md ./src/2-1-Kata-4.md ./src/2-1-Kata-3.md ./src/2-1-Kata-5.md ./src/2-1-Kata-6.md ./src/2-1-Kata-7.md ./src/2-1-Kata-8.md ./src/2-1-Kata-9.md ./src/2-1-Kata-10.md ./src/2-1-Kata-11.md ./src/2-1-Kata-12.md ./src/2-1-Kata-13.md ./src/3-0-2-was-ist-markdown.md ./src/3-0-1-proprietaeres-Format-zu-MD.md


REM Delete Old Versions
echo Deleting old versions ...
del %filename%.*

REM Create Web Version (mkdocs)
echo Creating Web Version ...
mkdocs build

REM Create Microsoft Word Version (docx)
echo Creating Word version ...
pandoc metadata.yaml --from markdown -s --resource-path="./src" --number-sections -V lang=de-de -o %filename%.docx %chapters%

REM Create HTML Version (html)
echo Creating HTML version ...
pandoc metadata.yaml --from markdown -s --resource-path="./src" --number-sections -V lang=de-de -o %filename%.html %chapters%

REM Create PDF Version (pdf)
echo Creating PDF version ...
pandoc metadata.yaml --from markdown -s --resource-path="./src" --template lernOS --number-sections --toc -V lang=de-de -o %filename%.pdf %chapters%

REM Create eBook Versions (epub, mobi)
echo Creating eBook versions ...
magick -density 300 %filename%.pdf[0] src/images/ebook-cover.jpg
magick mogrify -size 2500x2500 -resize 2500x2500 src/images/ebook-cover.jpg
magick mogrify -crop 1563x2500+102+0 src/images/ebook-cover.jpg
pandoc metadata.yaml --from markdown -s --resource-path="./src" --epub-cover-image=src/images/ebook-cover.jpg --number-sections --toc -V lang=de-de -o %filename%.epub %chapters%
ebook-convert %filename%.epub %filename%.mobi
