using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;
using eBiblioteka.Shared.Services;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.JsonPatch;

namespace eBiblioteka.Application
{
    public class UsersService : BaseService<User, UserDto, UserUpsertDto, UsersSearchObject, IUsersRepository>, IUsersService
    {
        private readonly ICryptoService _cryptoService;
        private readonly IPhotosService _photosService;
        private readonly IValidator<UserChangePasswordDto> _passwordValidator;


        public UsersService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpsertDto> validator, ICryptoService cryptoService, IPhotosService photosService, IValidator<UserChangePasswordDto> passwordValidator) : base(mapper, unitOfWork, validator)
        {
            _cryptoService = cryptoService;
            _photosService = photosService;
            _passwordValidator = passwordValidator;
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

            if (dto.ProfilePhoto != null)
            {
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data = dto.ProfilePhoto;
                var photo = await _photosService.AddAsync(photoUpsertDto);
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

            var user = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);// uvjeka await koristiti

            if (user == null)
                throw new UserNotFoundException();

            var exsistringProfilePhotoId = user.ProfilePhotoId ?? 0;

            Mapper.Map(dto, user);

            if (!dto.Password.IsNullOrEmpty())
            {
                user.PasswordSalt = _cryptoService.GenerateSalt();
                user.PasswordHash = _cryptoService.GenerateHash(dto.Password, user.PasswordSalt);
            }
            if (dto.ProfilePhoto == null && exsistringProfilePhotoId > 0)// ne može se null dodsjeliti 0
            {
                user.ProfilePhotoId = exsistringProfilePhotoId;
            }
            else if (dto.ProfilePhoto != null)
            {
                if (exsistringProfilePhotoId > 0)
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringProfilePhotoId, Data = dto.ProfilePhoto };
                    await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.ProfilePhoto };
                    var photo = await _photosService.AddAsync(photoUpsertDto);
                    user.ProfilePhotoId = photo.Id;
                }
            }

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<UserDto>(user);
        }

        public async Task<UserDto> ChangeEmailAsync(int userId, JsonPatchDocument jsonPatch, CancellationToken cancellationToken = default)
        {
           var user=   await CurrentRepository.ChangeEmailAsync(userId, jsonPatch, cancellationToken);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<UserDto>(user);

        }

        public async Task ChangePasswordAsync(UserChangePasswordDto dto, CancellationToken cancellationToken = default)
        {
            await _passwordValidator.ValidateAsync(dto, cancellationToken); //nisi bio dodao validator u registry

            var user = await CurrentRepository.GetByIdAsync(dto.Id, cancellationToken);

            if (user == null)
                throw new UserNotFoundException();

            if (!_cryptoService.Verify(user.PasswordHash, user.PasswordSalt, dto.Password))
                throw new UserWrongCredentialsException();

            user.PasswordSalt = _cryptoService.GenerateSalt();
            user.PasswordHash = _cryptoService.GenerateHash(dto.NewPassword, user.PasswordSalt);

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
        }



        public async Task PayMembershipAsync(int userId, CancellationToken cancellationToken = default)
        {
            var user = await CurrentRepository.GetByIdAsync(userId, cancellationToken);

            if (user == null)
                throw new UserNotFoundException();
            if (user.RoleId != 3)
            {
                throw new Exception("Only customers can pay mebership");
            }
            if (user.IsActiveMembership)
                throw new Exception("Membership is already activated");

            DateTime date = DateTime.Now;

            user.PurchaseDate = date;

            var exp= date.AddYears(1);
            user.ExpirationDate = exp;

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
        }
    }
}
