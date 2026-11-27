export function notFound(_request, response) {
  response.status(404).json({
    status: 'error',
    message: 'Endpoint não encontrado.',
  });
}
