# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cuda

DESCRIPTION="An open source library that allows detailed logging of program execution for parallel applications"
HOMEPAGE="http://www.tu-dresden.de/die_tu_dresden/zentrale_einrichtungen/zih/forschung/software_werkzeuge_zur_unterstuetzung_von_programmierung_und_optimierung/vampirtrace"
SRC_URI="http://wwwpub.zih.tu-dresden.de/%7Emlieber/dcount/dcount.php?package=vampirtrace&get=${P}.tar.gz"

SLOT="0"
LICENSE="vampir"
KEYWORDS="~amd64"
IUSE="cuda"

DEPEND="
	virtual/mpi
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.0.0 )"

src_prepare() {
	use cuda && cuda_src_prepare
}

src_configure() {
	econf $(use_with cuda cuda-dir "${EPREFIX}"/opt/cuda)
}

src_install() {
	default
	# avoid collisions with app-text/lcdf-typetools:
	mv "${D}/usr/bin/otfinfo" "${D}/usr/bin/otfinfo.vampir"
	mv "${D}/usr/lib/debug/usr/bin/otfinfo.debug" "${D}/usr/lib/debug/usr/bin/otfinfo.vampir.debug"
	# libtool is already installed:
	rm "${D}/usr/share/libtool"
}
