FROM python:3.12-slim-bookworm      
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]


# mudança para versao slim do python 3.12
# melhor aproveitamento de cache do docker para instalar dependencias
# exposicao da porta 8000
