using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eBiblioteka.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class author_modif_genrebook : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_BookGenres_BookId",
                table: "BookGenres");

            migrationBuilder.DropColumn(
                name: "BirthDate",
                table: "Authors");

            migrationBuilder.DropColumn(
                name: "MortalDate",
                table: "Authors");

            migrationBuilder.AddColumn<int>(
                name: "BirthYear",
                table: "Authors",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "MortalYear",
                table: "Authors",
                type: "int",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "BirthYear", "MortalYear" },
                values: new object[] { 1910, 1982 });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BirthYear", "MortalYear" },
                values: new object[] { 1982, 1975 });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "BirthYear", "MortalYear" },
                values: new object[] { 1564, 1616 });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "BirthYear", "MortalYear" },
                values: new object[] { 1805, 1875 });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "BirthYear", "MortalYear" },
                values: new object[] { 1694, 1778 });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "BirthYear", "MortalYear" },
                values: new object[] { 1828, 1906 });

            migrationBuilder.CreateIndex(
                name: "IX_BookGenres_BookId_GenreId",
                table: "BookGenres",
                columns: new[] { "BookId", "GenreId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_BookGenres_BookId_GenreId",
                table: "BookGenres");

            migrationBuilder.DropColumn(
                name: "BirthYear",
                table: "Authors");

            migrationBuilder.DropColumn(
                name: "MortalYear",
                table: "Authors");

            migrationBuilder.AddColumn<DateTime>(
                name: "BirthDate",
                table: "Authors",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "MortalDate",
                table: "Authors",
                type: "datetime2",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "BirthDate", "MortalDate" },
                values: new object[] { new DateTime(1910, 4, 26, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1982, 7, 11, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BirthDate", "MortalDate" },
                values: new object[] { new DateTime(1892, 10, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1975, 3, 13, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "BirthDate", "MortalDate" },
                values: new object[] { new DateTime(1564, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1616, 4, 23, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "BirthDate", "MortalDate" },
                values: new object[] { new DateTime(1805, 4, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1875, 8, 4, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "BirthDate", "MortalDate" },
                values: new object[] { new DateTime(1805, 4, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1875, 8, 4, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "BirthDate", "MortalDate" },
                values: new object[] { new DateTime(1828, 3, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1906, 5, 23, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.CreateIndex(
                name: "IX_BookGenres_BookId",
                table: "BookGenres",
                column: "BookId");
        }
    }
}
