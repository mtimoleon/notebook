```
public class JwtMiddleware
{
    private readonly RequestDelegate _next;
    private readonly IConfiguration _configuration;

    public JwtMiddleware(RequestDelegate next, IConfiguration configuration)
    {
        _next = next;
        _configuration = configuration;
    }

    public async Task Invoke(HttpContext context)
    {
        var token = context.Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();
        if (token != null)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]);
            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = true, // Set this to true to check for expiration
                ClockSkew = TimeSpan.Zero // Set this to zero to prevent time offset
            };

            try
            {
                var claimsPrincipal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);
                context.Items["User"] = claimsPrincipal;
            }
            catch (SecurityTokenExpiredException)
            {
                context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                await context.Response.WriteAsync("The token has expired.");
                return;
            }
            catch (Exception)
            {
                context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                await context.Response.WriteAsync("The token is invalid.");
                return;
            }
        }

        await _next(context);
    }
}
```
 
This middleware reads the JWT token from the Authorization header of the incoming request and validates it using the ValidateToken method of the JwtSecurityTokenHandler class. If the token is valid, it sets the User property of the HttpContext.Items dictionary to the claims principal of the token. If the token is invalid or has expired, it returns an HTTP 401 Unauthorized response.
 
You can then add this middleware to your ASP.NET Core application’s pipeline using the UseMiddleware extension method:
 
app.UseMiddleware\<JwtMiddleware\>();