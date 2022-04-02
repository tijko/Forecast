#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Forecast/Forecast.csproj", "Forecast/"]
RUN dotnet restore "Forecast/Forecast.csproj"
COPY . .
WORKDIR "/src/Forecast"
RUN dotnet build "Forecast.csproj" -c Release -o /app/build

#RUN dotnet test "....UnitTests.csproj" --logger "trx;LogFileName=...trx" 

FROM build AS publish
RUN dotnet publish "Forecast.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Forecast.dll"]
