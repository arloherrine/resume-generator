#!/usr/bin/env bash

set -euf -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p "${DIR}/output"
mkdir -p "${DIR}/gen"

function generate_html {
    cp "${DIR}/resume.css" "${DIR}/output"
    mustache resume.html.mustache > "${DIR}/gen/resume.html"
    cp "${DIR}/gen/resume.html" "${DIR}/output/resume.html"
}

function generate_pdf {
    mustache resume.tex.mustache > "${DIR}/gen/resume.tex"
    cp "${DIR}/gen/resume.tex" "${DIR}/output/resume.tex"

    cp "${DIR}/gen/resume.tex" "${DIR}/tex_template/resume.tex"
    (cd "${DIR}/tex_template" && xelatex -output-directory="${DIR}/gen" "resume.tex")
    rm "${DIR}/tex_template/resume.tex"
    cp "${DIR}/gen/resume.pdf" "${DIR}/output/resume.pdf"
}

tee >(generate_html) >(generate_pdf) > /dev/null

