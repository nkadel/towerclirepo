
# Created by pyp2rpm-3.3.10
%global pypi_name jq
%global pypi_version 1.8.0

Name:           python-%{pypi_name}
Version:        %{pypi_version}
Release:        1%{?dist}
Summary:        jq is a lightweight and flexible JSON processor

License:        BSD 2-Clause
URL:            https://github.com/mwilliamson/jq.py
Source0:        %{pypi_source}

BuildRequires:  python%{python3_pkgversion}-devel
BuildRequires:  python%{python3_pkgversion}-setuptools
BuildRequires:  gcc

%description
jq.py: a lightweight and flexible JSON processor This project contains Python
bindings for jq < 1.7.1.Installation Wheels are built for various Python
versions and architectures on Linux and Mac OS X. On these platforms, you
should be able to install jq with a normal pip install:.. code-block:: sh pip
install jqIf a wheel is not available, the source for jq 1.7.1 is built. This
requires:*...

%package -n     python%{python3_pkgversion}-%{pypi_name}
Summary:        %{summary}
%{?python_provide:%python_provide python%{python3_pkgversion}-%{pypi_name}}

%description -n python%{python3_pkgversion}-%{pypi_name}
jq.py: a lightweight and flexible JSON processor This project contains Python
bindings for jq < 1.7.1.Installation Wheels are built for various Python
versions and architectures on Linux and Mac OS X. On these platforms, you
should be able to install jq with a normal pip install:.. code-block:: sh pip
install jqIf a wheel is not available, the source for jq 1.7.1 is built. This
requires:*...


%prep
%autosetup -n %{pypi_name}-%{pypi_version}
# Remove bundled egg-info
rm -rf %{pypi_name}.egg-info

%build
%py3_build

%install
%py3_install

%files -n python%{python3_pkgversion}-%{pypi_name}
%license LICENSE
%doc README.rst
#%%{python3_sitearch}/%{pypi_name}
%{python3_sitearch}/%{pypi_name}-%{pypi_version}-py%{python3_version}.egg-info
%{python3_sitearch}/%{pypi_name}.cpython*.so

%changelog
* Mon Sep 30 2024 Nico Kadel-Garcia <nkadel@gmail.com> - 1.8.0-1
- Initial package.
- Add binary library for jq.cpython*.so
