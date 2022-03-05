// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// <auto-generated/>

#nullable disable

using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace SiteOfRefuge.API
{
    public class SearchApi
    {
        private ILogger<SearchApi> _logger;

        /// <summary> Initializes a new instance of SearchApi. </summary>
        /// <param name="logger"> Class logger. </param>
        /// <exception cref="ArgumentNullException"> <paramref name="logger"/> is null. </exception>
        public SearchApi(ILogger<SearchApi> logger)
        {
            if (logger == null)
            {
                throw new ArgumentNullException(nameof(logger));
            }

            _logger = logger;
        }

        /// <summary> Attempt to find hosts that match the needs of a refugee. This id has to match with the id in the access token. </summary>
        /// <param name="req"> Raw HTTP Request. </param>
        /// <param name="id"> Refugee id in UUID/GUID format. </param>
        /// <param name="cancellationToken"> The cancellation token provided on Function shutdown. </param>
        [FunctionName("FindMatchAsync_get")]
        public async Task<IActionResult> FindMatchAsync([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "search/{id}")] HttpRequest req, Guid id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            // Spec Defines: HTTP 200
            // Spec Defines: HTTP 403
            // Spec Defines: HTTP 404

            throw new NotImplementedException();
        }
    }
}
