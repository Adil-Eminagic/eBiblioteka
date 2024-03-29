﻿using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class QuotesService : BaseService<Quote, QuoteDto, QuoteUpsertDto, QuotesSearchObject, IQuotesRepository>, IQuotesService
    {
        public QuotesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<QuoteUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
