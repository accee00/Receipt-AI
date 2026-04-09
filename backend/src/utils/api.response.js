class ApiResponse {
    constructor({ statusCode, message, data = null, isSuccess = true }) {
        this.statusCode = statusCode;
        this.message = message;
        this.data = data;
        this.isSuccess = isSuccess;
    }
}

export { ApiResponse };