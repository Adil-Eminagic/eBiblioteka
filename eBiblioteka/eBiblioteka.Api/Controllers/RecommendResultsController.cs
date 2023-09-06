using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBiblioteka.Api.Controllers
{
    public class RecommendResultsController :BaseController
    {
        private readonly IRecommendResultsService _recommendResultsService;
        public RecommendResultsController(IRecommendResultsService service, ILogger<RecommendResultsController> logger, IRecommendResultsService recommendResultsService) : base(logger)
        {
            _recommendResultsService = recommendResultsService;
        }

        [Authorize]
        [HttpGet("{bookId}")]
        public virtual async Task<IActionResult> Get(int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await _recommendResultsService.GetByIdAsync(bookId, cancellationToken);
                if(dto == null) 
                { 
                return Ok(null);
                }
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting resource with ID {0}", bookId);
                return BadRequest(e.Message + " " + e?.InnerException);
            }
        }

        [Authorize]
        [HttpGet("GetPaged")]
        public virtual async Task<IActionResult> GetPaged([FromQuery] BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await _recommendResultsService.GetPagedAsync(searchObject, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting paged resources for page number {0}, with page size {1}", searchObject.PageNumber, searchObject.PageSize);
                return BadRequest(e.Message + " " + e?.InnerException);

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
