#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim-amd64 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim-amd64 AS build
WORKDIR /src
COPY ["Forecast/Forecast.csproj", "Forecast/"]

WORKDIR "/src/Forecast"
RUN dotnet restore "Forecast.csproj"
COPY Forecast/ .
RUN dotnet build "Forecast.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "Forecast.csproj" -c Release -o /app/publish

WORKDIR /
RUN rm -rf /src

WORKDIR /src
COPY ["ForecastXUnitTest/ForecastXUnitTest.csproj", "ForecastXUnitTest/"]
WORKDIR "/src/ForecastXUnitTest"
RUN dotnet restore "ForecastXUnitTest.csproj"
COPY ForecastXUnitTest/ .
RUN dotnet build "ForecastXUnitTest.csproj" -c Release -o /app
RUN dotnet test -c Release --results-directory /testresults --logger "trx;LogFileName=test_results.trx" "ForecastXUnitTest.csproj"

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Forecast.dll"]
