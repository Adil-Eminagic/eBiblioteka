using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eBiblioteka.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class name_property_rule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "isActive",
                table: "Users",
                newName: "IsActive");

            migrationBuilder.RenameColumn(
                name: "isRead",
                table: "Notifications",
                newName: "IsRead");

            migrationBuilder.RenameColumn(
                name: "isActive",
                table: "Books",
                newName: "IsActive");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "IsActive",
                table: "Users",
                newName: "isActive");

            migrationBuilder.RenameColumn(
                name: "IsRead",
                table: "Notifications",
                newName: "isRead");

            migrationBuilder.RenameColumn(
                name: "IsActive",
                table: "Books",
                newName: "isActive");
        }
    }
}
