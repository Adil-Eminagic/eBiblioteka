using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;
using eBiblioteka.Shared.Services;
using Microsoft.IdentityModel.Tokens;

namespace eBiblioteka.Application
{
    public class UsersService : BaseService<User, UserDto, UserUpsertDto, UsersSearchObject, IUsersRepository>, IUsersService
    {
        private readonly ICryptoService _cryptoService;
        private readonly IPhotosService _photosService;

        public UsersService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpsertDto> validator, ICryptoService cryptoService, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
            _cryptoService = cryptoService;
            _photosService = photosService;
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

            if(dto.ProfilePhoto != null)
            {
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data=dto.ProfilePhoto;
                var photo= await _photosService.AddAsync(photoUpsertDto);
                entity.ProfilePhotoId = photo.Id;
            }

            entity.PasswordSalt = _cryptoService.GenerateSalt();
            entity.PasswordHash = _cryptoService.GenerateHash(dto.Password!, entity.PasswordSalt);

          
            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<UserDto>(entity);
        }

        public async override Task<UserDto> UpdateAsync(UserUpsertDto dto, CancellationToken cancellationToken = default)
        {

           await ValidateAsync(dto, cancellationToken);

           var user= await CurrentRepository.GetByIdAsync(dto.Id.Value,cancellationToken);// uvjeka await koristiti

            if(user==null)
                throw new UserNotFoundException();

            var exsistringProfilePhotoId = user.ProfilePhotoId ?? 0;

            Mapper.Map(dto, user);

            if (!dto.Password.IsNullOrEmpty())
            {
                user.PasswordSalt= _cryptoService.GenerateSalt();
                user.PasswordHash = _cryptoService.GenerateHash(dto.Password,user.PasswordSalt );
            }
            if (dto.ProfilePhoto == null && exsistringProfilePhotoId>0)// ne može se null dodsjeliti 0
            {
                user.ProfilePhotoId = exsistringProfilePhotoId;
            }
            else if(dto.ProfilePhoto!=null) 
            {
                if (exsistringProfilePhotoId > 0)
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringProfilePhotoId, Data = dto.ProfilePhoto };
                    await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.ProfilePhoto };
                    var photo= await _photosService.AddAsync(photoUpsertDto);
                    user.ProfilePhotoId= photo.Id;
                }
            }

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<UserDto>(user);
        }

    }
}
