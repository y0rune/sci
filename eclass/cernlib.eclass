# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Author Sebastien Fabbro <bicatali@gentoo.org>
#
# A simple eclass to be used to install cernlib based packages.
# The packages so far have been based on Debian's ones,
# since they provide a fair amount of useful patches
# and already split and re-package the full tar balls.
#
# - Features:
# cernlib_unpack()        - unpack properly debian packages
# cernlib_patch()         - apply the big set of debian patches
# cernlib_src_unpack()    - apply the above two
# cernlib_src_compile()   - compile the package with the right options
# cernlib_src_install()   - install package and all docs
#
# - Variables:
# DEB_PN                   - Debian package name, default to $PN
# DEB_PV                   - Debian package version name, default to $PV.dfsg
# DEB_PR                   - Debian patch version, default to 1
# CERNLIB_PV               - CERNLIB version, default to 2006
#
inherit eutils multilib fortran

[[ -z "${DEB_PN}" ]] && DEB_PN="${PN}"
[[ -z "${DEB_PV}" ]] && DEB_PV="${PV}.dfsg"
[[ -z "${DEB_PR}" ]] && DEB_PR="1"

DESCRIPTION="CERN program library for High Energy Physics"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/cernlib"
LICENSE="GPL-2 LGPL-2 BSD"
SRC_URI="mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_PN}_${DEB_PV}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_PN}_${DEB_PV}-${DEB_PR}.diff.gz"
SLOT="0"
IUSE=""

DEPEND="virtual/motif
	virtual/lapack
	virtual/tetex
	dev-lang/cfortran
	x11-misc/imake
	x11-misc/makedepend"

RDEPEND="virtual/motif
	virtual/lapack
	dev-lang/cfortran"

if [[ "${PN}" != "cernlib" ]]; then
	[[ -z "${CERNLIB_PV}" ]] && CERNLIB_PV=2006
	DEPEND="${DEPEND} >=sci-physics/cernlib-${CERNLIB_PV}"
	RDEPEND="${RDEPEND} >=sci-physics/cernlib-${CERNLIB_PV}"
fi

RESTRICT="test"
FORTRAN="gfortran g77 ifc"
S=${WORKDIR}/${DEB_PN}-${DEB_PV}.orig

cernlib_unpack() {
	unpack ${A}
	epatch "${DEB_PN}_${DEB_PV}-${DEB_PR}".diff
}

cernlib_patch() {
	cd "${S}"
	cp debian/add-ons/Makefile .
	sed -i \
		-e 's:/usr/local:/usr:g' \
		Makefile || "sed'ing the Makefile failed"

	einfo "Applying Debian patches"
	emake -j1 \
		DEB_BUILD_OPTIONS="${FORTRANC} ${restrict}" \
		patch &> /dev/null || die "make patch failed"

	# since we depend on cfortran, do not use the one from cernlib
	# (adapted from debian/cernlib-debian.mk)
	mv -f src/include/cfortran/cfortran.h \
		src/include/cfortran/cfortran.h.disabled
	# create local LaTeX cache directory
	mkdir -p .texmf-var
}

cernlib_src_unpack() {
	cernlib_unpack
	cernlib_patch
}

cernlib_src_compile() {
	emake -j1 \
		DEB_BUILD_OPTIONS="${FORTRANC} nostrip" \
		|| die "emake failed"
}

cernlib_src_install() {
	emake \
		DEB_BUILD_OPTIONS="${FORTRANC} nostrip" \
		DESTDIR="${D}" \
		install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt NEWS copyright || die "dodoc failed"
	newdoc add-ons/README README.add-ons || die "newdoc failed"
}

cernlib_pkg_postinst() {
	elog "Gentoo ${PN} is based on Debian similar package."
	elog "Serious cernlib users might want to check:"
	elog "http://people.debian.org/~kmccarty/cernlib/"
	elog "for the changes and licensing from the original package"
	if use amd64; then
		elog "Please see the possible warnings in using ${PN} on 64 bits:"
		elog "/usr/share/doc/${PF}/README.*64*"
	fi
}

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst
