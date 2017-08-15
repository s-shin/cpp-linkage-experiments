#!/bin/bash
set -eu

for libhello_lib_type in SHARED STATIC; do
  for libhello_libsay_ver in v1 v2; do
    for libhello_visibility in on off; do
      for myapp_libsay_ver in v1 v2; do
        for myapp_static_link_of_shared_libhello in on off; do
          if [[ "$(uname)" != 'Linux' ]]; then
            myapp_static_link_of_shared_libhello=na
          fi
          dir="build-${libhello_lib_type}-${libhello_libsay_ver}-${libhello_visibility}-${myapp_libsay_ver}-${myapp_static_link_of_shared_libhello}"
          mkdir -p "$dir"
          pushd "$dir"
          cmake .. -GNinja \
            -DLIBHELLO_LIB_TYPE="${libhello_lib_type}" \
            -DLIBHELLO_LIBSAY_VER="${libhello_libsay_ver}" \
            -DLIBHELLO_VISIBILITY="${libhello_visibility}" \
            -DMYAPP_LIBSAY_VER="${myapp_libsay_ver}" \
            -DMYAPP_STATIC_LINK_OF_SHARED_LIBHELLO="${myapp_static_link_of_shared_libhello}"
          ninja
          popd
          if [[ "${myapp_static_link_of_shared_libhello}" = 'na' ]]; then
            break
          fi
        done
      done
    done
  done
done

echo "--- * --- * --- * --- * --- * --- * --- * --- * --- * --- * ---"

for dir in $(ls | grep build); do
  echo "===== ${dir} ====="
  for bin in libhello.dylib libhello.a myapp; do
    if [[ -f "${dir}/${bin}" ]]; then
      echo "${bin}: $(nm "${dir}/${bin}" | wc -l | tr -d '[:space:]')"
      nm "${dir}/${bin}" | grep -E 'Say|Hello'
    fi
  done
  echo '---'
  "${dir}/myapp"
  echo
done
