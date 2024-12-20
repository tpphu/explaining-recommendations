FROM continuumio/anaconda3:2019.10

# Cập nhật danh sách repository cho Debian Buster và bỏ debian-security
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i '/security/d' /etc/apt/sources.list && \
    apt-get update --allow-releaseinfo-change && \
    apt-get install -y \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt Jupyter Notebook
RUN conda install jupyterlab -y --quiet

# Sao chép mã nguồn từ kho lưu trữ vào container
WORKDIR /workspace
COPY . /workspace

# Cài đặt môi trường Python từ env.yml của kho lưu trữ
RUN conda env create -f env.yml && \
    conda clean -afy

# Kích hoạt môi trường Python khi container chạy
RUN echo "source activate sac2019_env" > ~/.bashrc

# Cài đặt các thư viện bổ sung (nếu cần)
RUN pip install -r requirements.txt || true

# Mở cổng Jupyter Notebook
CMD ["jupyter", "notebook", "--notebook-dir=/workspace", "--ip=*", "--port=8888", "--no-browser", "--allow-root"]
