#FROM debian:stretch-slim
FROM debian:buster-slim

# some steps below following https://www.mono-project.com/download/stable/#download-lin-debian
# also alternative Docker image implementation at https://www.github.com/danielguerra69/alpine-fiddler
# e.g. docker pull danielguerra/alpine-fiddler

RUN apt-get update \
  && apt-get install --no-install-recommends -y curl unzip apt-transport-https dirmngr gnupg ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

#RUN echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
RUN echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget \
  && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && curl -O http://ericlawrence.com/dl/MonoFiddler-v4484.zip
# ^^ in case that site goes down & Fiddler EXE missing, may want to keep a copy to build locally with instead
# or use internet archive wayback machine:
#RUN cd /tmp && curl -O https://web.archive.org/web/20161019061922/http://ericlawrence.com/dl/MonoFiddler-v4484.zip
# alternative installer download URLs?
# https://telerik-fiddler.s3.amazonaws.com/fiddler/FiddlerSetup.exe
# https://www.telerik.com/download/fiddler/fiddler4
# ^^ this one redirects to the actual EXE download I think
# how might you run the official EXE installer (v5.0.20204.45441 for .NET 4.6.1, dated 11/3/2020) in CLI mode on docker/mono?
# perhaps simply install manually on Windows machine, then zip up the contents for this docker build & extract
# organizing it in same folder structure C:\Users\<USERNAME>\AppData\Local\Programs\Fiddler --> /app
# Also maybe consider packaging in Fiddler Everywhere as well the same way (run installer manually, zip content), 2 tools in one image
# https://downloads.getfiddler.com/win/Fiddler%20Everywhere%201.5.1.exe

RUN unzip /tmp/MonoFiddler-v4484.zip

EXPOSE 8888

ENTRYPOINT ["mono", "/app/Fiddler.exe"]
