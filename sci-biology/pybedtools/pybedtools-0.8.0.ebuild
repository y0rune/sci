# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Use BED and GFF files from python using BEDtools"
HOMEPAGE="http://pythonhosted.org/pybedtools/"
SRC_URI="https://github.com/daler/pybedtools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-biology/bedtools"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"
