# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Estimate codon usage bias and its statistical significance"
HOMEPAGE="
	http://bigd.big.ac.cn/tools/cat
	http://cbb.big.ac.cn/Software
	http://code.google.com/p/composition-analysis-toolkit
	http://www.cbrc.kaust.edu.sa/CAT"
SRC_URI="ftp://download.big.ac.cn/bigd/tools/${PN}${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

PATCHES=( "${FILESDIR}"/CAT-1.3_respect_env_variables.patch )

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}${PV}"

src_compile(){
	cd src || die
	emake
}

src_install(){
	dobin CAT
}
