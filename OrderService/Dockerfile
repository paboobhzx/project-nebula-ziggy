#i'm using a silicon based mac. Need this to for it to use the processor instructions instead of emulating instructions
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["OrderService.csproj", "./"]
RUN dotnet restore

COPY . . 
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app 
COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "OrderService.dll"]
