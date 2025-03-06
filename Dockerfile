# Usa la imagen oficial del SDK de .NET para compilar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copia solo los archivos de proyecto para aprovechar la caché de Docker
COPY ["src/IAC.Api/IAC.Api.csproj", "./IAC.Api/"]
WORKDIR /src/IAC.Api
RUN dotnet restore "IAC.Api.csproj"

# Volver a la raíz y copiar el código fuente después de restaurar
WORKDIR /src
COPY src/ .

# Publica la aplicación en modo Release
RUN dotnet publish "IAC.Api/IAC.Api.csproj" -c Release -o /app/published /p:UseAppHost=false

# Usa la imagen de ASP.NET Core Runtime para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Crear un usuario sin privilegios por seguridad
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser

# Copiar solo los archivos publicados desde la etapa de build
COPY --from=build /app/published .

# Expone el puerto 80 para recibir tráfico HTTP
EXPOSE 8080

# Define el comando de inicio del contenedor
ENTRYPOINT ["dotnet", "IAC.Api.dll"]
