import mongoose, { Schema } from "mongoose";
import mongooseAggregatePaginate from "mongoose-aggregate-paginate-v2";

const expenseSchema = new Schema({
    merchant: {
        type: String,
        required: true,
        trim: true,
    },
    totalAmount: {
        type: Number,
        required: true,
    },
    items: [
        {
            type: Map,
            of: String,
        }
    ],
    date: {
        type: Date,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    description: {
        type: String,
    },
    notes: {
        type: String,
    },
    receiptImage: {
        type: String,
    },
    user: {
        type: Schema.Types.ObjectId,
        ref: "User",
    },

}, { timestamps: true });

expenseSchema.plugin(mongooseAggregatePaginate);
export const Expense = mongoose.model("Expense", expenseSchema);
