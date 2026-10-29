import { ZodError } from 'zod';

export function validateRequest(schema) {
  return async (request, response, next) => {
    try {
      request.validated = await schema.parseAsync({
        body: request.body,
        query: request.query,
        params: request.params,
      });
      next();
    } catch (error) {
      if (!(error instanceof ZodError)) {
        next(error);
        return;
      }

      response.status(400).json({
        status: 'error',
        message: 'Falha na validação dos dados de entrada.',
        errors: error.issues.map((issue) => ({
          field: issue.path.join('.'),
          message: issue.message,
        })),
      });
    }
  };
}
