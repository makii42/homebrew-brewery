require "language/go"

class Gottaw < Formula
  desc "Local command building your code as soon as you save modifications"
  homepage "https://github.com/makii42/gottaw"
  url "https://github.com/makii42/gottaw/archive/v0.1.1.tar.gz"
  sha256 "0dfaf1cb8272899514ac153b0fc62c32ff172a598ebcf578ec46e92da0d44b0f"
  head "https://github.com/makii42/gottaw.git", :branch => "develop"
  
  depends_on "go" => :build

  go_resource "github.com/0xAX/notificator" do
    url "https://github.com/0xAX/notificator.git",
      :revision => "6bcea42e61381c13704c7fb6eb2438950f335832"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
      :revision => "62e9147c64a1ed519147b62a56a14e83e2be02c1"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
      :revision => "739734461d1c916b6c72a63d7efda2b27edb369f"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1.git",
      :revision => "629574ca2a5df945712d3079857300b5e4da0236"
  end

  go_resource "gopkg.in/urfave/cli.v1" do
    url "https://gopkg.in/urfave/cli.v1.git",
      :revision => "0bdeddeeb0f650497d603c4ad7b20cfe685682f6"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/makii42/gottaw").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/makii42/gottaw" do
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
