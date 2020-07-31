FROM ubuntu:18.04
LABEL maintainer="Beth Tseng <Beth_Tseng@htc.com>"

RUN apt-get update && apt-get install -yq \
			python3.7 python3-pip python3.7-dev \
                        htop nano git wget \
                        libglib2.0-0 autoconf automake \
                        libtool build-essential unzip \
                        libarchive-dev vim

# Install Python dependencies.
ADD requirements.txt /
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

# Install Jupyter.
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN jupyter contrib nbextension install
RUN jupyter nbextension enable codefolding/main
RUN echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8080" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "jupyter notebook --no-browser --allow-root" >> /usr/local/bin/run_notebook && chmod +x /usr/local/bin/run_notebook

# Welcome message.
ADD welcome_message.txt /
RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' \
        >> /etc/bash.bashrc \
        ; cat welcome_message.txt > /etc/motd

WORKDIR /root
EXPOSE 8080
