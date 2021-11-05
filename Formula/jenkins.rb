class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.319/jenkins.war"
  sha256 "50e9c818cda1bdf3ba7e2a1e590f027a889bd527d5bcfc2daea944ce351c7105"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54ff174b8a8ae077680517132e61dec833542c359597baf238a0bbdb5081c66a"
    sha256 cellar: :any_skip_relocation, big_sur:       "54ff174b8a8ae077680517132e61dec833542c359597baf238a0bbdb5081c66a"
    sha256 cellar: :any_skip_relocation, catalina:      "54ff174b8a8ae077680517132e61dec833542c359597baf238a0bbdb5081c66a"
    sha256 cellar: :any_skip_relocation, mojave:        "54ff174b8a8ae077680517132e61dec833542c359597baf238a0bbdb5081c66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92cb94ca4b56f7afa43494edbc85acc4360b4b9c487e43bf33b5788697cc606b"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git"
    depends_on "maven" => :build
  end

  depends_on "openjdk@11"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk@11"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins", java_version: "11"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli", java_version: "11"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@11"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
