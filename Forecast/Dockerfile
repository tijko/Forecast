#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /src
COPY ["Forecast.csproj", "Forecast/"]
COPY ["../ForecastXUnitTest/ForecastXUnitTest.csproj", "ForecastTest/"]
RUN dotnet restore "Forecast.csproj"
RUN dotnet restore "../ForecastTest/ForecastXUnitTest.csproj"
COPY . .
WORKDIR "/src/Forecast"
RUN dotnet build "Forecast.csproj" -c Release -o /app/build
WORKDIR "/src/ForecastTest"
RUN dotnet build "ForecastXUnitTest.csproj" -c Release -o /app
RUN dotnet test "ForecastXUnitTest.csproj"

FROM build AS publish
RUN dotnet publish "Forecast.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Forecast.dll"]
