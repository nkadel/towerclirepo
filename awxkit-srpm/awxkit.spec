#
# spec file for package awxkit
#

# pypi naming of module and components is deranged
%global pypi_name awxkit
%global pypi_modname awxkit
%global pypi_shortname awxkit
%global pypi_version 24.6.1

Name:           %{pypi_name}
Version:        %{pypi_version}
Release:        1.1
Summary:        CLI for the Ansible Automation Platform and AWX
License:        Apache-2.0
URL:            https://github.com/ansible/tower-cli
Source:         %{pypi_source}
BuildRequires:  pyproject-rpm-macros
# For SuSE
#BuildRequires:  python%%{python3_pkgversion}-base
# For RHEL
BuildRequires:  python%{python3_pkgversion}
BuildRequires:  python%{python3_pkgversion}-devel
BuildRequires:  python%{python3_pkgversion}-setuptools
BuildRequires:  python%{python3_pkgversion}-pip
BuildRequires:  python%{python3_pkgversion}-wheel

BuildRequires:  python%{python3_pkgversion}-pytest
BuildRequires:  python%{python3_pkgversion}-PyYAML
BuildRequires:  python%{python3_pkgversion}-requests
BuildRequires:  python%{python3_pkgversion}-cryptography
BuildRequires:  python%{python3_pkgversion}-jq
BuildRequires:  python%{python3_pkgversion}-websocket-client >= 0.57.0
# SECTION
BuildRequires:  fdupes
BuildRequires:  python%{python3_pkgversion}-rpm-macros

Requires:       python%{python3_pkgversion}-PyYAML
Requires:       python%{python3_pkgversion}-requests

# For SuSE
#Requires(post): update-alternatives
#Requires(postun): update-alternatives
Requires(post): chkconfig
Requires(postun): chkconfig

BuildArch:      noarch
#%%python_subpackages

%description
CLI to manage the ansible-automation-platform and AWX platform

%prep
%autosetup -n %{pypi_name}-%{version}
#cp %{SOURCE1} .
echo %{version} > VERSION

%build
%pyproject_wheel

%install
%pyproject_install
#%%python_clone -a %%{buildroot}%%{_bindir}/tower-cli
#%%python_expand %%fdupes %%{buildroot}%%{$python3_sitelib}

%post
#%%python_install_alternative tower-cli

%postun
#%%python_uninstall_alternative tower-cli

%files
%doc README.md
#T%license LICENSE
%{python3_sitelib}/%{pypi_shortname}/
%{python3_sitelib}/%{pypi_modname}-%{version}.dist-info
%{_bindir}/*

%changelog
* Sun Sep 29 2024 Nico Kadel-Garcia <nkadel@gmail.com
- Repackage SuSE RPM for RHEL use
