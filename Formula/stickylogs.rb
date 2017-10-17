require "language/go"

class Stickylogs < Formula
  desc "Persistent log tail for docker containers"
  homepage "https://github.com/makii42/stickylogs"
  url "https://github.com/makii42/stickylogs/archive/v0.1.0.tar.gz"
  sha256 "74972fd238ddc24b6182cdd73e89630994d6320e7f1ee64c7fca2f3171dfbe23"
  head "https://github.com/makii42/stickylogs.git", :branch => "develop"
  
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/makii42/stickylogs").install buildpath.children
    cd "src/github.com/makii42/stickylogs" do
      system "go", "get", "."
      system "go", "build", "-o", bin/"stickylogs"
    end
  end
end
