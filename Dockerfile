FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-stage
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ["WebApi.Swagger.QuickStart/WebApi.Swagger.QuickStart.csproj", "WebApi.Swagger.QuickStart/"]
COPY ["WebApi.Swagger.QuickStart.Model/WebApi.Swagger.QuickStart.Model.csproj", "WebApi.Swagger.QuickStart.Model/"]
COPY ["WebApi.Swagger.QuickStart.Services/WebApi.Swagger.QuickStart.Services.csproj", "WebApi.Swagger.QuickStart.Services/"]
COPY ["WebApi.Swagger.QuickStart.DAL/WebApi.Swagger.QuickStart.DAL.csproj", "WebApi.Swagger.QuickStart.DAL/"]
RUN dotnet restore "WebApi.Swagger.QuickStart/WebApi.Swagger.QuickStart.csproj"

# Copy everything then build / publish
COPY . .

FROM build-stage AS publish-stage
WORKDIR /app
RUN dotnet publish -c Release -o /app/out -r linux-x64

# Build runtime image
FROM mcr.microsoft.com/dotnet/sdk:6.0
WORKDIR /app
COPY --from=publish-stage /app/out .
ENTRYPOINT ["dotnet", "WebApi.Swagger.QuickStart.dll"]
