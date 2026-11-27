export function validateRequest(schema, requestProperty) {
  return (request, response, next) => {
    const result = schema.safeParse(request[requestProperty]);

    if (!result.success) {
      response.status(400).json({
        status: 'error',
        message: 'Falha na validação dos dados de entrada.',
        errors: result.error.issues.map((issue) => ({
          field: issue.path.join('.'),
          message: issue.message,
        })),
      });
      return;
    }

    request.validated ??= {};
    request.validated[requestProperty] = result.data;
    next();
  };
}
