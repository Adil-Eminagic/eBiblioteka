
using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public partial class DatabaseContext
    {
        private readonly DateTime _dateTime = new(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local);

        string image = "iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAM1BMVEXk5ueutLeqsbTn6eqpr7PJzc/j5ebf4eLZ3N2wtrnBxsjN0NLGysy6v8HT1tiss" +
            "ra8wMNxTKO9AAAFDklEQVR4nO2d3XqDIAxAlfivoO//tEOZ" +
            "WzvbVTEpic252W3PF0gAIcsyRVEURVEURVEURVEURVEURVEURVEURVEURVEURflgAFL/AirAqzXO9R7XNBVcy9TbuMHmxjN6lr92cNVVLKEurVfK/zCORVvW8iUBnC0" +
            "2dj+Wpu0z0Y6QlaN5phcwZqjkOkK5HZyPAjkIjSO4fIdfcOwFKkJlX4zPu7Ha1tIcwR3wWxyFhRG6g4Je0YpSPDJCV8a2Sv2zd1O1x/2WMDZCwljH+clRrHfWCLGK8REMiql//2si5+DKWKcWeAGcFMzzNrXC/0TUwQ2s6+Lhl" +
            "cwjTMlYsUIQzPOCb7YBiyHopyLXIEKPEkI/TgeuiidK/R9FniUDOjRDpvm0RhqjMyyXNjDhCfIMYl1gGjIMIuYsnGEYRMRZOMMunaLVwpWRW008v6fY" +
            "KDIzxCwVAeNSO90BJW6emelYBRF/kHpYGVaoxTDAaxOFsfP9y8hpJ4xd7gOcij7JNGQ1EYFgkPJa1jQEiYZXRaRINKxSDUW9n+FT82lSKadkiru9/4XPqSLWOekGPoY05TAvLm9orm+YWuwHoBHkZKijNBJGmeb61eL" +
            "6Ff/6q7bLr7yvv3vKGhpDRjvgjGaPz+gUg6YgcvpyAR2FIZ9U6nEEyZRTovmEU32KichpGn7C17XrfyH9gK/c0CMP05HZIM2uf9sEveizKveBy9/6Qt7o89ne33D525cfcIMW6ab+TMEukQbQbu+xu7X3A9bChmWaC" +
            "eAkG17bpntwXgWxHaMzGPmUaR5dQZiKqRVeUZ3047fi3nAu28h4CHxCsZAgmEH8Y27jJAhm8c+5RQzRQNVGhVFSfxOYIjp/pP7RxzjevYXVGf4eLt+BJ1vCuLuLkrgABgCGXZ2wik5uty+oBvNirI6mkzhAf4Gsb" +
            "58Hcm67Jzd+KwD10BYPLL3e0MjvKrgAULnOfveF/O4N2Xb9BZom3gJes3F9X5Zze8/6Yt09b4CrqsEjUv8oFBaR2rl+6CZr2xVrp24o/WitBKuGrrpl1+bFkmK2qXTON4VpbdfLa7o7y/WdLxG7lm2Lqh2clOwTeg" +
            "bvc/vj2U78CwhA87Bn8G5Nk3eOb0Nsr9flz3sG78UUtue4kpv1xvjg3TMay62BMl" +
            "TlP+vrOMnJsRmt/ze0jsfkPPYdAH57hK+34PeOyc8XIXu5xT2HsUkdZz+adwg8HGFfQ3K5jtDvbUiO4Di9/ywHGrL88pDizZ++oTp+an+SMX/ndymUCwmHMdO7yuOx83pUx/eEMU0AvxWndwgidAqOZ8ypCwdEfv" +
            "vEo6D9HwpA8wzvmOJEqAg9ySu8g4x0Hb9hSB/BANEKJ+LbPBU0lzbAJs4xt1AoshKkUGQmiH8/jJ0gdhTTLmSegHlPE0oOdXALnqDjKYh3px//fSgSWG8UqfrrIICzYYSJXRr9BSPbpNzw7gBjKjKOYI7ReIGqQRIap5" +
            "+5MdjyvuDkExvGeXSlONWZAP3/AZBwJohU7QJRGU+cTVH18ELmRPNBmibW6MT/k1b0XhdkRBvyT6SB6EYv/GvhSmRNpGngRULsAlxMCGNXp7w3FfdEbTEEDdLI9TdIKRUzUesa3I461ER8cpNT7gMRhpKmYVS9ELOgCU" +
            "Qsa4SsulciKiLbY+AnHD8cpuhISsnxpamI84sbDq9qYJgf8wiiOBrC7Ml7M7ZECCqKoiiKo" +
            "iiKoiiKoijv5AvJxlZRyNWWLwAAAABJRU5ErkJggg==";


        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedCountries(modelBuilder);
            SeedCities(modelBuilder);
            SeedBooks(modelBuilder);
            SeedPhotos(modelBuilder);
            SeedQuotes(modelBuilder);
            SeedAuthors(modelBuilder);
            SeedGenres(modelBuilder);
            SeedBookGenres(modelBuilder);
            SeedUsers(modelBuilder);
            SeedGenders(modelBuilder);
            SeedRoles(modelBuilder);

        }

        private void SeedRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Role>().HasData(
                  new()
                  {
                      Id = 1,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Value = "Superadmin"

                  },
                  new()
                  {
                      Id = 2,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Value="Admin"
                  },
                  new()
                  {
                      Id = 3,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Value = "User"
                  }

             );
        }

        private void SeedGenders(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Gender>().HasData(
                  new()
                  {
                      Id = 1,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Value="Muški"

                  },
                  new()
                  {
                      Id = 2,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Value="Ženski"
                  },
                  new()
                  {
                      Id = 3,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Value = "Drugo"
                  }

             );
        }

        private void SeedPhotos(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Photo>().HasData(
                 new()
                 {
                     Id = 1,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     Data = image

                 },
                 new()
                 {
                     Data = image,
                     Id = 2,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                 }

            );
        }


        private void SeedCountries(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Country>().HasData(
                new()
                {
                    Id = 1,
                    Name = "Bosnia i Herzegovina",
                    Abbreviation = "BIH",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "Hrvatska",
                    Abbreviation = "HR",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 3,
                    Name = "Srbija",
                    Abbreviation = "SRB",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 4,
                    Name = "Crna Gora",
                    Abbreviation = "CG",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 5,
                    Name = "Slovenija",
                    Abbreviation = "SLO",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 6,
                    Name = "Austrija",
                    Abbreviation = "AT",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                 new()
                 {
                     Id = 7,
                     Name = "Ujedninjeno Kraljevstvo",
                     Abbreviation = "UK",
                     IsActive = true,
                     CreatedAt = _dateTime,
                     ModifiedAt = null
                 },
                 new()
                 {
                     Id = 8,
                     Name = "Danska",
                     Abbreviation = "DAN",
                     IsActive = true,
                     CreatedAt = _dateTime,
                     ModifiedAt = null
                 },
                  new()
                  {
                      Id = 9,
                      Name = "Francuska",
                      Abbreviation = "FRA",
                      IsActive = true,
                      CreatedAt = _dateTime,
                      ModifiedAt = null
                  },
                  new()
                  {
                      Id = 10,
                      Name = "Norveška",
                      Abbreviation = "NOR",
                      IsActive = true,
                      CreatedAt = _dateTime,
                      ModifiedAt = null
                  }
                 );
        }

        private void SeedCities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<City>().HasData(
                new()
                {
                    Id = 1,
                    Name = "Mostar",
                    ZipCode = "88000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "Sarajevo",
                    ZipCode = "77000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 3,
                    Name = "Zenica",
                    ZipCode = "72000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }

        private void SeedUsers(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>().HasData(
                 new User()
                 {
                     Id = 1,
                     FirstName = "Site",
                     LastName = "Admin",
                     Email = "site.admin@gmail.com",
                     RoleId=1,
                     GenderId = 1,
                     PasswordHash = "b4I5yA4Mp+0Pg1C3EsKU17sS13eDExGtBjjI07Vh/JM=", //Plain text: test
                     PasswordSalt = "1wQEjdSFeZttx6dlvEDjOg==",
                     PhoneNumber = "38761123456",
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     CountryId = 1

                 }

                 );
        }

        private void SeedAuthors(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Author>().HasData(
                new()
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    FullName = "Meša Selimović",
                    GenderId=1,
                    BirthDate = new DateTime(1910, 4, 26),
                    MortalDate = new DateTime(1982, 7, 11),
                    CountryId = 1,
                    

                },
                 new()
                 {
                     Id = 2,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     FullName = "Ivo Andrić",
                     GenderId = 1,
                     BirthDate = new DateTime(1892, 10, 10),
                     MortalDate = new DateTime(1975, 3, 13),
                     CountryId = 1
                 },
                new()
                {
                    Id = 3,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    FullName = "Wiliam Shakspeare",
                    GenderId = 1,
                    BirthDate = new DateTime(1564, 4, 1),
                    MortalDate = new DateTime(1616, 4, 23),
                    CountryId = 7,
                },
                new()
                {
                    Id = 4,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    FullName = "Hans Christian Andersen",
                    GenderId = 1,
                    BirthDate = new DateTime(1805, 4, 2),
                    MortalDate = new DateTime(1875, 8, 4),
                    CountryId = 8,
                },
                new()
                {
                    Id = 5,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    FullName = "Voltaire",
                    GenderId= 1,
                    BirthDate = new DateTime(1805, 4, 2),
                    MortalDate = new DateTime(1875, 8, 4),
                    CountryId = 9,
                },
                new()
                {
                    Id = 6,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    FullName = "Henrik Ibsen",
                    BirthDate = new DateTime(1828, 3, 20),
                    MortalDate = new DateTime(1906, 5, 23),
                    GenderId=1,
                    CountryId = 10
                }



                );
        }

        private void SeedGenres(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Genre>().HasData(
                  new()
                  {
                      Id = 1,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Name = "Roman",

                  },
                  new()
                  {
                      Id = 2,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Name = "Drama",
                  },
                  new()
                  {
                      Id = 3,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Name = "Bajka",
                  },
                  new()
                  {
                      Id = 4,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Name = "Tragedija",
                  },
                  new()
                  {
                      Id = 5,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Name = "Komedija",
                  }
                  );

        }


        private void SeedBookGenres(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BookGenre>().HasData(
                 new()
                 {
                     Id = 1,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 1,
                     GenreId = 1

                 },
                 new()
                 {
                     Id = 2,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 2,
                     GenreId = 1
                 },
                 new()
                 {
                     Id = 3,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 3,
                     GenreId = 2
                 },
                 new()
                 {
                     Id = 4,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 4,
                     GenreId = 2
                 },
                 new()
                 {
                     Id = 5,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 5,
                     GenreId = 3
                 },
                 new()
                 {
                     Id = 6,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 6,
                     GenreId = 3
                 },
                 new()
                 {
                     Id = 7,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     BookId = 7,
                     GenreId = 3
                 },
                  new()
                  {
                      Id = 8,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      BookId = 8,
                      GenreId = 3
                  }
                 );
        }



        private void SeedBooks(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Book>().HasData(
                new()
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    Title = "Tvrdjava",
                    PublishingYear = 1970,
                    OpeningCount = 0,
                    //CoverPhotoId = 1,
                    AuthorID = 1,
                },
                new()
                {
                    Id = 2,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    Title = "Na Drini cuprija",
                    PublishingYear = 1945,
                    OpeningCount = 0,
                    //CoverPhotoId = 1,
                    AuthorID = 2,
                },
                 new()
                 {
                     Id = 3,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     Title = "Romeo i Julija",
                     PublishingYear = 1597,
                     OpeningCount = 0,
                     //CoverPhotoId = 1,
                     AuthorID = 3,
                 },
                 new()
                 {
                     Id = 4,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     Title = "Hamlet",
                     PublishingYear = 1602,
                     OpeningCount = 0,
                     //CoverPhotoId = 1,
                     AuthorID = 3,
                 },
                 new()
                 {
                     Id = 5,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     Title = "Ružno pače",
                     PublishingYear = 1843,
                     OpeningCount = 0,
                     //CoverPhotoId = 1,
                     AuthorID = 4,
                 },
                  new()
                  {
                      Id = 6,
                      CreatedAt = _dateTime,
                      ModifiedAt = null,
                      Title = "Snjeguljica",
                      PublishingYear = 1845,
                      OpeningCount = 0,
                      //CoverPhotoId = 1,
                      AuthorID = 4,
                  },
                   new()
                   {
                       Id = 7,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Princeza na zrnu graška",
                       PublishingYear = 1835,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 4,
                   },
                   new()
                   {
                       Id = 8,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Mala sirena",
                       PublishingYear = 1837,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 4,
                   },
                   new()
                   {
                       Id = 9,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Derviš i smrt",
                       PublishingYear = 1966,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 1,
                   },
                   new()
                   {
                       Id = 10,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Tišine",
                       PublishingYear = 1961,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 1,
                   },
                   new()
                   {
                       Id = 11,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Krug",
                       PublishingYear = 1983,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 1,
                   },
                   new()
                   {
                       Id = 12,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Prokleta Avlija",
                       PublishingYear = 1954,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 2,
                   },
                   new()
                   {
                       Id = 13,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Travnička hronika",
                       PublishingYear = 1945,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 2,
                   },
                   new()
                   {
                       Id = 14,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Gospođica",
                       PublishingYear = 1925,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 2,
                   },
                   new()
                   {
                       Id = 15,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Omerpaša Latas",
                       PublishingYear = 1968,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 2,
                   },
                   new()
                   {
                       Id = 16,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Kralj Lir",
                       PublishingYear = 1606,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 3,
                   },
                   new()
                   {
                       Id = 17,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Julije Cezar",
                       PublishingYear = 1599,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 3,
                   },
                   new()
                   {
                       Id = 18,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Bura",
                       PublishingYear = 1611,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 3,
                   },
                   new()
                   {
                       Id = 19,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Edip",
                       PublishingYear = 1718,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 5,
                   },
                   new()
                   {
                       Id = 20,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Brut",
                       PublishingYear = 1730,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 5,
                   },
                   new()
                   {
                       Id = 21,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Nanin",
                       PublishingYear = 1749,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 5,
                   },
                   new()
                   {
                       Id = 22,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Mahomet",
                       PublishingYear = 1741,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 5,
                   },
                   new()
                   {
                       Id = 23,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Gospođica",
                       PublishingYear = 1837,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 2,
                   },
                   new ()
                   {
                       Id = 24,
                       CreatedAt = _dateTime,
                       ModifiedAt = null,
                       Title = "Nora (lutkina kuća)",
                       PublishingYear = 1879,
                       OpeningCount = 0,
                       //CoverPhotoId = 1,
                       AuthorID = 6,
                   },
                    new()
                    {
                        Id = 25,
                        CreatedAt = _dateTime,
                        ModifiedAt = null,
                        Title = "Hedda Gabler",
                        PublishingYear = 1890,
                        OpeningCount = 0,
                        //CoverPhotoId = 1,
                        AuthorID = 6,
                    },
                     new()
                     {
                         Id = 26,
                         CreatedAt = _dateTime,
                         ModifiedAt = null,
                         Title = "Duhovi",
                         PublishingYear = 1881,
                         OpeningCount = 0,
                         //CoverPhotoId = 1,
                         AuthorID = 6,
                     },
                     new()
                     {
                         Id = 27,
                         CreatedAt = _dateTime,
                         ModifiedAt = null,
                         Title = " Neprijatelj naroda",
                         PublishingYear = 1882,
                         OpeningCount = 0,
                         //CoverPhotoId = 1,
                         AuthorID = 5,
                     }
                   
                );
        }

        private void SeedQuotes(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Quote>().HasData(
                new()
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    Content = "Citat iz tvrdjave",
                    BookId = 1,
                },
                new()
                {
                    Id = 2,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    BookId = 2,
                    Content = "Citat na drini cuprija"
                }

                );
        }






    }
}
