export function errorHandler(error, _request, response, _next) {
  const statusCode =
    Number.isInteger(error.statusCode) && error.statusCode >= 400
      ? error.statusCode
      : 500;

  if (statusCode === 500) {
    console.error('Erro inesperado na API:', error);
  }

  response.status(statusCode).json({
    status: 'error',
    message:
      statusCode === 500 ? 'Erro interno do servidor.' : error.message,
  });
}
