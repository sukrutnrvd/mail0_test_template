FROM python:3.10-slim-bullseye

ENV PYTHONUNBUFFERED=1
ENV DATABASE_URL=""
ENV DEBUG=True
ENV SECRET_KEY=changeme
ENV ALLOWED_HOSTS=*
ENV CSRF_TRUSTED_ORIGINS=
ENV TIME_ZONE=UTC

RUN apt-get update && apt-get install -y libcairo2-dev gcc git

RUN git clone https://github.com/horilla-opensource/horilla.git

WORKDIR /horilla

RUN rm -rf .env.dist

RUN echo "DATABASE_URL=$DATABASE_URL" > .env.dist
RUN echo "DEBUG=$DEBUG" >> .env.dist
RUN echo "SECRET_KEY=$SECRET_KEY" >> .env.dist
RUN echo "ALLOWED_HOSTS=$ALLOWED_HOSTS" >> .env.dist
RUN echo "CSRF_TRUSTED_ORIGINS=$CSRF_TRUSTED_ORIGINS" >> .env.dist
RUN echo "TIME_ZONE=$TIME_ZONE" >> .env.dist

RUN pip install -r requirements.txt

RUN chmod +x /horilla/entrypoint.sh && sed -i 's/\r$//' /horilla/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/horilla/entrypoint.sh"]
CMD ["python3", "manage.py", "runserver"]
