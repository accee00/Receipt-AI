class ApiError extends Error {
    constructor({ statusCode, message = "An unexpected error." }) {
        super(message);
        this.statusCode = statusCode;
        this.isSuccess = false;
    }
}

export { ApiError };