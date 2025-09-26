import express from "express";
import axios from "axios";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();

// ✅ Allow requests only from your deployed Flutter Web app
app.use(
  cors({
    origin: "https://paystack-transaction-test-app.vercel.app",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(express.json());

// Health check
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// Paystack transaction initialization
app.post("/api/v1/transaction/initialize", async (req, res) => {
  const { email, amount } = req.body;

  const url = "https://api.paystack.co/transaction/initialize";

  try {
    const response = await axios.post(
      url,
      { email, amount },
      {
        headers: {
          Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
          "Content-Type": "application/json", // proper case
        },
      }
    );

    console.log(response.data);

    res.json(response.data);
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).json({ error: error.response?.data || error.message });
  }
});

// ✅ Use process.env.PORT for deployment platforms
const PORT = process.env.PORT || 3000;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
