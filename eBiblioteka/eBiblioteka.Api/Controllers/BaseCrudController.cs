﻿using Microsoft.AspNetCore.Mvc;

using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public abstract class BaseCrudController<TDto, TUpsertDto, TSearchObject, TService> : BaseController
        where TDto : BaseDto
        where TUpsertDto : BaseUpsertDto
        where TSearchObject : BaseSearchObject
        where TService : IBaseService<int, TDto, TUpsertDto, TSearchObject>
    {
        protected readonly TService Service;

        
        protected BaseCrudController(TService service, ILogger<BaseController> logger) : base(logger)
        {
            Service = service;
        }

        [Authorize]
        [HttpGet("{id}")]
        public virtual async Task<IActionResult> Get(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.GetByIdAsync(id, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting resource with ID {0}", id);
                return BadRequest();
            }
        }

        [Authorize]
        [HttpGet("GetPaged")]
        public virtual async Task<IActionResult> GetPaged([FromQuery] TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.GetPagedAsync(searchObject, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting paged resources for page number {0}, with page size {1}", searchObject.PageNumber, searchObject.PageSize);
                return BadRequest();
            }
        }

        [Authorize]
        [HttpPost]
        public virtual async Task<IActionResult> Post([FromBody] TUpsertDto upsertDto, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.AddAsync(upsertDto, cancellationToken);
                return Ok(dto);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when posting resource");
                return BadRequest();
            }
        }

        [Authorize]
        [HttpPut]
        public virtual async Task<IActionResult> Put([FromBody] TUpsertDto upsertDto, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.UpdateAsync(upsertDto, cancellationToken);
                return Ok(dto);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when updating resource");
                return BadRequest();
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public virtual async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                await Service.RemoveByIdAsync(id, cancellationToken);
                return Ok();
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when deleting resource");
                return BadRequest(e.Message);
            }
        }

        protected IActionResult ValidationResult(List<ValidationError> errors)
        {
            var dictionary = new Dictionary<string, List<string>>();

            foreach (var error in errors)
            {
                if (!dictionary.ContainsKey(error.PropertyName))
                    dictionary.Add(error.PropertyName, new List<string>());

                dictionary[error.PropertyName].Add(error.ErrorCode);
            }

            return BadRequest(new
            {
                Errors = dictionary.Select(i => new
                {
                    PropertyName = i.Key,
                    ErrorCodes = i.Value
                })
            });
        }
    }
}
