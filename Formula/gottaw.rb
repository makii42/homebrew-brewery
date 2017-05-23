class Gottaw < Formula
  desc "Local command building your code as soon as you save modifications"
  homepage "https://github.com/makii42/gottaw"
  url "https://github.com/makii42/gottaw/archive/v0.0.3.tar.gz"
  sha256 "7da09a64c8bffe837cf3856c22fc025521e359523f1764e21bf13533b0ea8116"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/makii42/gottaw").install buildpath.children
    cd "src/github.com/makii42/gottaw" do
      system "go", "get"
      system "go", "build", "-o", bin/"gottaw"
    end
    bash_completion.install "src/gopkg.in/urfave/cli.v1/autocomplete/bash_autocomplete" => "gottaw"
  end

  test do
    (testpath/"foo.go").write <<-EOS.undent
      package foo

    EOS
    assert_match "Identified default Golang", shell_output("#{bin}/gottaw defaults")
  end
end
