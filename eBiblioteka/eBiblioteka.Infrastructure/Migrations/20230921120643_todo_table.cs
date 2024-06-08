using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eBiblioteka.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class todo_table : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ToDo210923s",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ActivityName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ActivityDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FinshingDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    StatusCode = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ToDo210923s", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ToDo210923s_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "ToDo210923s",
                columns: new[] { "Id", "ActivityDescription", "ActivityName", "CreatedAt", "FinshingDate", "ModifiedAt", "StatusCode", "UserId" },
                values: new object[,]
                {
                    { 1, "Potrebno je upaltiti članarinu za 20 dana", "Placanje clanarine", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2023, 11, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "U toku", 3 },
                    { 2, "Potrebno je izvrsiti aktivnost 2", "Aktivnost 2", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2023, 11, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Relaizovana", 3 },
                    { 3, "Potrebno je izvrsiti aktivnost 3", "Aktivnost 3", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2023, 11, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "U toku", 4 },
                    { 4, "Potrebno je itvršiti aktivnost 4", "Aktivnost 4", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2023, 11, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Relaizovana", 4 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_ToDo210923s_UserId",
                table: "ToDo210923s",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ToDo210923s");
        }
    }
}
