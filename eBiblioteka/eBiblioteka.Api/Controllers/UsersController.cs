using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class UsersController : BaseCrudController<UserDto, UserUpsertDto, UsersSearchObject, IUsersService>
    {
        public UsersController(IUsersService service, ILogger<UsersController> logger) : base(service, logger)
        {
        }

        [Authorize]
        [HttpPatch("{userId}")]
        public async Task<IActionResult> ChangeEmailAsync([FromBody] JsonPatchDocument jsonPatch, [FromRoute] int userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.ChangeEmailAsync(userId, jsonPatch, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when updating email");
                return BadRequest(e.Message + ", " + e?.InnerException);
            }
        }

        [Authorize]
        [HttpPut("ChangePassword")]
        public async Task<IActionResult> ChangePassword([FromBody] UserChangePasswordDto dto, CancellationToken cancellationToken = default)
        {
            try
            {
                await Service.ChangePasswordAsync(dto, cancellationToken);
                return Ok();
            }
            catch (Exception e)
            {

                Logger.LogError(e, "Problem when updating password");
                return BadRequest(e.Message + ", " + e?.InnerException);
            }
        }

        [Authorize]
        [HttpPut("PayMembership")]
        public async Task<IActionResult> PayMembership([FromQuery] int userId, CancellationToken cancellationToken = default)
        {
            try
            {
                await Service.PayMembershipAsync(userId, cancellationToken);
                return Ok("Membership successfully activated");
            }
            catch (Exception e)
            {

                Logger.LogError(e, "Problem when paying membership");
                return BadRequest(e.Message + ", " + e?.InnerException);
            }
        }

    }


}
