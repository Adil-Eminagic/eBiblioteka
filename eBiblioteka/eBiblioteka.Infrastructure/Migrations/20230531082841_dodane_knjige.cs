using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eBiblioteka.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class dodane_knjige : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Photos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Data = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Photos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Books",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ShortDescription = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PublishingDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    OpeningCount = table.Column<int>(type: "int", nullable: false),
                    CoverPhotoId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Books", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Books_Photos_CoverPhotoId",
                        column: x => x.CoverPhotoId,
                        principalTable: "Photos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Quotes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BookId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Quotes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Quotes_Books_BookId",
                        column: x => x.BookId,
                        principalTable: "Books",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Photos",
                columns: new[] { "Id", "CreatedAt", "Data", "ModifiedAt" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAM1BMVEXk5ueutLeqsbTn6eqpr7PJzc/j5ebf4eLZ3N2wtrnBxsjN0NLGysy6v8HT1tissra8wMNxTKO9AAAFDklEQVR4nO2d3XqDIAxAlfivoO//tEOZWzvbVTEpic252W3PF0gAIcsyRVEURVEURVEURVEURVEURVEURVEURVEURVEURflgAFL/AirAqzXO9R7XNBVcy9TbuMHmxjN6lr92cNVVLKEurVfK/zCORVvW8iUBnC02dj+Wpu0z0Y6QlaN5phcwZqjkOkK5HZyPAjkIjSO4fIdfcOwFKkJlX4zPu7Ha1tIcwR3wWxyFhRG6g4Je0YpSPDJCV8a2Sv2zd1O1x/2WMDZCwljH+clRrHfWCLGK8REMiql//2si5+DKWKcWeAGcFMzzNrXC/0TUwQ2s6+LhlcwjTMlYsUIQzPOCb7YBiyHopyLXIEKPEkI/TgeuiidK/R9FniUDOjRDpvm0RhqjMyyXNjDhCfIMYl1gGjIMIuYsnGEYRMRZOMMunaLVwpWRW008v6fYKDIzxCwVAeNSO90BJW6emelYBRF/kHpYGVaoxTDAaxOFsfP9y8hpJ4xd7gOcij7JNGQ1EYFgkPJa1jQEiYZXRaRINKxSDUW9n+FT82lSKadkiru9/4XPqSLWOekGPoY05TAvLm9orm+YWuwHoBHkZKijNBJGmeb61eL6Ff/6q7bLr7yvv3vKGhpDRjvgjGaPz+gUg6YgcvpyAR2FIZ9U6nEEyZRTovmEU32KichpGn7C17XrfyH9gK/c0CMP05HZIM2uf9sEveizKveBy9/6Qt7o89ne33D525cfcIMW6ab+TMEukQbQbu+xu7X3A9bChmWaCeAkG17bpntwXgWxHaMzGPmUaR5dQZiKqRVeUZ3047fi3nAu28h4CHxCsZAgmEH8Y27jJAhm8c+5RQzRQNVGhVFSfxOYIjp/pP7RxzjevYXVGf4eLt+BJ1vCuLuLkrgABgCGXZ2wik5uty+oBvNirI6mkzhAf4Gsb58Hcm67Jzd+KwD10BYPLL3e0MjvKrgAULnOfveF/O4N2Xb9BZom3gJes3F9X5Zze8/6Yt09b4CrqsEjUv8oFBaR2rl+6CZr2xVrp24o/WitBKuGrrpl1+bFkmK2qXTON4VpbdfLa7o7y/WdLxG7lm2Lqh2clOwTegbvc/vj2U78CwhA87Bn8G5Nk3eOb0Nsr9flz3sG78UUtue4kpv1xvjg3TMay62BMlTlP+vrOMnJsRmt/ze0jsfkPPYdAH57hK+34PeOyc8XIXu5xT2HsUkdZz+adwg8HGFfQ3K5jtDvbUiO4Di9/ywHGrL88pDizZ++oTp+an+SMX/ndymUCwmHMdO7yuOx83pUx/eEMU0AvxWndwgidAqOZ8ypCwdEfvvEo6D9HwpA8wzvmOJEqAg9ySu8g4x0Hb9hSB/BANEKJ+LbPBU0lzbAJs4xt1AoshKkUGQmiH8/jJ0gdhTTLmSegHlPE0oOdXALnqDjKYh3px//fSgSWG8UqfrrIICzYYSJXRr9BSPbpNzw7gBjKjKOYI7ReIGqQRIap5+5MdjyvuDkExvGeXSlONWZAP3/AZBwJohU7QJRGU+cTVH18ELmRPNBmibW6MT/k1b0XhdkRBvyT6SB6EYv/GvhSmRNpGngRULsAlxMCGNXp7w3FfdEbTEEDdLI9TdIKRUzUesa3I461ER8cpNT7gMRhpKmYVS9ELOgCUQsa4SsulciKiLbY+AnHD8cpuhISsnxpamI84sbDq9qYJgf8wiiOBrC7Ml7M7ZECCqKoiiKoiiKoiiKoijv5AvJxlZRyNWWLwAAAABJRU5ErkJggg==", null },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "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", null }
                });

            migrationBuilder.InsertData(
                table: "Books",
                columns: new[] { "Id", "CoverPhotoId", "CreatedAt", "ModifiedAt", "OpeningCount", "PublishingDate", "ShortDescription", "Title" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 0, new DateTime(1980, 5, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Tvrdjava" },
                    { 2, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 0, new DateTime(1980, 5, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Na Drini cuprija" }
                });

            migrationBuilder.InsertData(
                table: "Quotes",
                columns: new[] { "Id", "BookId", "Content", "CreatedAt", "ModifiedAt" },
                values: new object[,]
                {
                    { 1, 1, "Citat iz tvrdjave", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null },
                    { 2, 2, "Citat na drini cuprija", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Books_CoverPhotoId",
                table: "Books",
                column: "CoverPhotoId");

            migrationBuilder.CreateIndex(
                name: "IX_Quotes_BookId",
                table: "Quotes",
                column: "BookId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Quotes");

            migrationBuilder.DropTable(
                name: "Books");

            migrationBuilder.DropTable(
                name: "Photos");
        }
    }
}
