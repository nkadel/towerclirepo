%global pypi_name click

%if 0%{?rhel} > 7
# Disable python2 build by default
%bcond_with python2
%else
%bcond_without python2
%endif

Name:           python-%{pypi_name}
Version:        6.7
Release:        8%{?dist}
Summary:        Simple wrapper around optparse for powerful command line utilities

License:        BSD
URL:            https://github.com/mitsuhiko/click
Source0:        %{url}/archive/%{version}/%{pypi_name}-%{version}.tar.gz
# https://bugzilla.redhat.com/show_bug.cgi?id=1500962
# https://github.com/pallets/click/pull/838
Patch0:         0001-Remove-outdated-comment-about-Click-3.0.patch
Patch1:         0002-Add-pytest-option-to-not-capture-warnings.patch
Patch2:         0003-Catch-and-test-pytest-warning.patch

BuildArch:      noarch

%global _description \
click is a Python package for creating beautiful command line\
interfaces in a composable way with as little amount of code as necessary.\
It's the "Command Line Interface Creation Kit".  It's highly configurable but\
comes with good defaults out of the box.

%description %{_description}

%if %{with python2}
%package -n     python2-%{pypi_name}
Summary:        %{summary}
%{?python_provide:%python_provide python2-%{pypi_name}}
BuildRequires:  python2-devel
%if ! (0%{?rhel} && 0%{?rhel} <= 7)
BuildRequires:  python2-setuptools
# pytest in base RHEL is too old, we'll skip the tests there
BuildRequires:  python2-pytest >= 2.8
%else
BuildRequires:  python-setuptools
%endif

%description -n python2-%{pypi_name} %{_description}

Python 2 version.
%endif # with python2

%package -n     python%{python3_pkgversion}-%{pypi_name}
Summary:        %{summary}
%{?python_provide:%python_provide python%{python3_pkgversion}-%{pypi_name}}
BuildRequires:  python%{python3_pkgversion}-devel
BuildRequires:  python%{python3_pkgversion}-setuptools
BuildRequires:  python%{python3_pkgversion}-pytest >= 2.8

%description -n python%{python3_pkgversion}-%{pypi_name} %{_description}

Python 3 version.

%prep
%autosetup -n %{pypi_name}-%{version} -p1

%build
%if %{with python2}
%py2_build
%endif # with python2
%py3_build

%install
%if %{with python2}
%py2_install
%endif # with python2
%py3_install

%check
export PYTHONPATH=$(pwd)
export LC_ALL=en_US.UTF-8
%if %{with python2}
%if ! (0%{?rhel} && 0%{?rhel} <= 7)
# pytest in base RHEL is too old, we'll skip the tests there
py.test-%{python2_version} tests --tb=long --verbose
%endif
%endif # with python2
py.test-%{python3_version} tests --tb=long --verbose

%if %{with python2}
%files -n python2-%{pypi_name}
%license LICENSE
%doc README CHANGES
%{python2_sitelib}/%{pypi_name}-*.egg-info/
%{python2_sitelib}/%{pypi_name}/
%endif # with python2

%files -n python%{python3_pkgversion}-%{pypi_name}
%license LICENSE
%doc README CHANGES
%{python3_sitelib}/%{pypi_name}-*.egg-info/
%{python3_sitelib}/%{pypi_name}/

%changelog
* Fri Jun 22 2018 Charalampos Stratakis <cstratak@redhat.com> - 6.7-8
- Conditionalize the python2 subpackage

* Fri Feb 09 2018 Fedora Release Engineering <releng@fedoraproject.org> - 6.7-7
- Rebuilt for https://fedoraproject.org/wiki/Fedora_28_Mass_Rebuild

* Thu Oct 12 2017 Igor Gnatenko <ignatenkobrain@fedoraproject.org> - 6.7-6
- Fixup EPEL packaging

* Thu Oct 12 2017 Carl George <carl@george.computer> - 6.7-6
- Add EPEL compatibility

* Thu Oct 12 2017 Igor Gnatenko <ignatenkobrain@fedoraproject.org> - 6.7-5
- Fix FTBFS

* Thu Jul 27 2017 Fedora Release Engineering <releng@fedoraproject.org> - 6.7-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_27_Mass_Rebuild

* Sat Feb 11 2017 Fedora Release Engineering <releng@fedoraproject.org> - 6.7-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_26_Mass_Rebuild

* Mon Jan 09 2017 Miro Hrončok <mhroncok@redhat.com> - 6.7-2
- Fixed a copy-paste bug in %%python_provide (rhbz#1411169)

* Sat Jan 07 2017 Igor Gnatenko <i.gnatenko.brain@gmail.com> - 6.7-1
- Update to 6.7
- Adopt to packaging guidelines

* Tue Dec 13 2016 Charalampos Stratakis <cstratak@redhat.com> - 6.6-4
- Enable tests

* Fri Dec 09 2016 Charalampos Stratakis <cstratak@redhat.com> - 6.6-3
- Rebuild for Python 3.6
- Disable python3 tests for now

* Tue Jul 19 2016 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 6.6-2
- https://fedoraproject.org/wiki/Changes/Automatic_Provides_for_Python_RPM_Packages

* Mon Apr 18 2016 Charalampos Stratakis <cstratak@redhat.com> - 6.6-1
- Update to 6.6
- Removed non-applied patch file.

* Tue Mar 08 2016 Robert Kuska <rkuska@redhat.com> - 6.3-1
- Update to 6.3

* Thu Feb 04 2016 Fedora Release Engineering <releng@fedoraproject.org> - 6.2-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_24_Mass_Rebuild

* Tue Jan 19 2016 Robert Kuska <rkuska@redhat.com> - 6.2-1
- Update to 6.2

* Wed Oct 14 2015 Robert Kuska <rkuska@redhat.com> - 5.1-2
- Rebuilt for Python3.5 rebuild

* Mon Aug 24 2015 Robert Kuska <rkuska@redhat.com> - 5.1-1
- Update to 5.1

* Mon Aug 03 2015 Robert Kuska <rkuska@redhat.com> - 4.1-1
- Update to 4.1

* Thu Jun 18 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.0-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_23_Mass_Rebuild

* Sun May 31 2015 Robert Kuska <rkuska@redhat.com> - 4.0-2
- Rebuilt

* Wed Apr 01 2015 Robert Kuska <rkuska@redhat.com> - 4.0-1
- Update to 4.0

* Fri Oct 03 2014 Robert Kuska <rkuska@redhat.com> - 3.3-1
- Update to 3.3

* Sun Aug 24 2014 Robert Kuska <rkuska@redhat.com> - 3.2-2
- Add patch for exception check of TypeError

* Sun Aug 24 2014 Robert Kuska <rkuska@redhat.com> - 3.2-1
- Update to 3.2

* Mon Aug 18 2014 Robert Kuska <rkuska@redhat.com> - 3.1-1
- Update to 3.1

* Wed Jul 16 2014 Robert Kuska <rkuska@redhat.com> - 2.4-1
- Update to 2.4

* Mon Jun 30 2014 Robert Kuska <rkuska@redhat.com> - 2.2-1
- Update to 2.2

* Thu Jun 12 2014 Robert Kuska <rkuska@redhat.com> - 2.0-1
- Update to 2.0

* Fri Jun 06 2014 Robert Kuska <rkuska@redhat.com> - 1.1-3
- Make click own its folder
- Use pythonX_version macros from devel package

* Thu May 29 2014 Robert Kuska <rkuska@redhat.com> - 1.1-2
- Remove __pycache__ folder from tests

* Mon May 12 2014 Robert Kuska <rkuska@redhat.com> - 1.1-1
- Update source

* Wed May 07 2014 Robert Kuska <rkuska@redhat.com> - 0.6-1
- Initial package.
