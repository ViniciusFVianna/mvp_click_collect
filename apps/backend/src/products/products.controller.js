import {
  createProduct,
  deleteProduct,
  findProductById,
  listProducts,
  updateProduct,
} from './products.service.js';

export async function getProducts(_request, response, next) {
  try {
    const products = await listProducts();
    response.status(200).json({ data: products });
  } catch (error) {
    next(error);
  }
}

export async function getProduct(request, response, next) {
  try {
    const product = await findProductById(request.validated.params.id);
    response.status(200).json({ data: product });
  } catch (error) {
    next(error);
  }
}

export async function postProduct(request, response, next) {
  try {
    const product = await createProduct(request.validated.body);
    response.status(201).json({ data: product });
  } catch (error) {
    next(error);
  }
}

export async function putProduct(request, response, next) {
  try {
    const product = await updateProduct(
      request.validated.params.id,
      request.validated.body,
    );
    response.status(200).json({ data: product });
  } catch (error) {
    next(error);
  }
}

export async function deleteProductById(request, response, next) {
  try {
    await deleteProduct(request.validated.params.id);
    response.status(204).end();
  } catch (error) {
    next(error);
  }
}
