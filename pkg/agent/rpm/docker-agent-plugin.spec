%global debug_package %{nil}

Name: docker-agent-plugin
Version: %{_version}
Release: %{_release}%{?dist}
Epoch: 0
Source0: agent.tgz
Summary: Docker Agent plugin for the Docker CLI
Group: Tools/Docker
License: Apache-2.0
URL: https://github.com/docker/docker-agent
Vendor: Docker
Packager: Docker <support@docker.com>

Enhances: docker-ce-cli

BuildRequires: bash
BuildRequires: gcc

%description
Docker Agent plugin for the Docker CLI.

This plugin provides the 'docker agent' subcommand.

The binary can also be run standalone as 'docker-agent'.

%prep
%setup -q -c -n src -a 0

%build
pushd ${RPM_BUILD_DIR}/src/agent
    mkdir -p bin && \
    go build -trimpath -ldflags="-w -X github.com/docker/docker-agent/pkg/version.Version=%{_origversion} -X github.com/docker/docker-agent/pkg/version.Commit=%{_commit}" -o bin/docker-agent .
popd

%check
ver="$(${RPM_BUILD_ROOT}%{_libexecdir}/docker/cli-plugins/docker-agent docker-cli-plugin-metadata | awk '{ gsub(/[\",:]/,\"\")}; $1 == \"Version\" { print $2 }')"; \
	test "$ver" = "%{_origversion}" && echo "PASS: docker-agent version OK" || (echo "FAIL: docker-agent version ($ver) did not match" && exit 1)

%install
pushd ${RPM_BUILD_DIR}/src/agent
    install -D -p -m 0755 bin/docker-agent ${RPM_BUILD_ROOT}%{_libexecdir}/docker/cli-plugins/docker-agent
popd
for f in LICENSE README.md; do
    install -D -p -m 0644 "${RPM_BUILD_DIR}/src/agent/$f" "docker-agent-plugin-docs/$f"
done

%files
%doc docker-agent-plugin-docs/*
%license docker-agent-plugin-docs/LICENSE
%{_libexecdir}/docker/cli-plugins/docker-agent

%post

%preun

%postun

%changelog
