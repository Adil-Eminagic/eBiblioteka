using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eBiblioteka.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class seed_notif_userquiz : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "Id", "Content", "CreatedAt", "IsRead", "ModifiedAt", "Title", "UserId" },
                values: new object[,]
                {
                    { 1, "Dobro došli u aplikaciju eBiblioteka desktop", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), false, null, "Dobrodošli", 1 },
                    { 2, "Vi ste superadmin u ovoj aplikaciji", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), false, null, "Vaša uloga", 1 }
                });

            migrationBuilder.InsertData(
                table: "UserQuizzes",
                columns: new[] { "Id", "CreatedAt", "ModifiedAt", "Percentage", "QuizId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 80.0, 1, 5 },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 50.0, 2, 5 },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 100.0, 1, 3 },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 0.0, 2, 3 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "UserQuizzes",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "UserQuizzes",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "UserQuizzes",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "UserQuizzes",
                keyColumn: "Id",
                keyValue: 4);
        }
    }
}
