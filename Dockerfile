FROM continuumio/anaconda3

# Cài đặt Jupyter Notebook
RUN conda install jupyter -y --quiet

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
