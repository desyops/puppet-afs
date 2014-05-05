require 'facter'
Facter.add(:afs_cache_size) do
  confine :osfamily => "Debian"
  cache_dir = "/var/cache/openafs"
  setcode do
    # df: use POSIX output format, set block size to 1K and limit to local fs
    line = Facter::Util::Resolution.exec("df -Pkl #{cache_dir} 2>/dev/null | tail -1")
    if line.nil?
      # cache_dir does not exist, yet return something safe
      "100000"
    elsif line.split(" ")[5] != cache_dir
      # If cache_dir is not on a separate partition,
      # fall back to 100MB disk cache
      "100000"
    else
      blocks = line.split(" ")[1].to_i
      # Formula to calculate cachesize from AFS init script on RHEL osfamily
      ((blocks * 0.7).to_i / 1000) * 1000
    end
  end
end
