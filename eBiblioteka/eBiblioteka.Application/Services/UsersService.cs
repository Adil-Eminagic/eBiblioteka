using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;
using eBiblioteka.Shared.Services;

namespace eBiblioteka.Application
{
    public class UsersService : BaseService<User, UserDto, UserUpsertDto, UsersSearchObject, IUsersRepository>, IUsersService
    {
        private readonly ICryptoService _cryptoService;

        public UsersService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpsertDto> validator, ICryptoService cryptoService) : base(mapper, unitOfWork, validator)
        {
            _cryptoService = cryptoService;
        }
        public async Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
        {
            var user = await CurrentRepository.GetByEmailAsync(email, cancellationToken);
            return Mapper.Map<UserSensitiveDto>(user);
        }

        public async override Task<UserDto> AddAsync(UserUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<User>(dto);

            entity.PasswordSalt = _cryptoService.GenerateSalt();
            entity.PasswordHash = _cryptoService.GenerateHash(dto.Password!, entity.PasswordSalt);

          
            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<UserDto>(entity);
        }

    }
}
