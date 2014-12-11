Facter.debug("Running modinfo openafs")
modinfo_output = Facter::Util::Resolution.exec('modinfo openafs 2>/dev/null')
lsmod_output = Facter::Util::Resolution.exec('lsmod')
if lsmod_output[0]
  is_loaded = !!(/^openafs\s/.match(lsmod_output))
  Facter.add('kmod_isloaded_openafs') do
    confine :kernel => "Linux"
    setcode do
      is_loaded
    end
  end
else
  Facter.debug("Running lsmod openafs didn't work out")
end
if modinfo_output[0]
  file = /filename: \s+(.+)$/.match(modinfo_output)[1]
  if file
    Facter.add('kmod_filename_openafs') do
      confine :kernel => "Linux"
      setcode do
        file
      end
    end
  end
  vermagic = /vermagic: \s+(.+)$/.match(modinfo_output)[1]
  if vermagic
    Facter.add('kmod_vermagic_openafs') do
      confine :kernel => "Linux"
      setcode do
        vermagic
      end
    end
  end
else
  Facter.debug("Running modinfo openafs didn't work out")
end
