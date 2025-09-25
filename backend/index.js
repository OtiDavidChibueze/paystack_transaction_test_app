import express from "express";
import axios from "axios";
import cors from "cors";
import dotenv from "dotenv";
dotenv.config();

const app = express();

app.use(express.json());
app.use(
  cors({
    origin: "https://paystack-transaction-test-app.vercel.app",
  })
);

app.get("/", (req, res) => {
  res.send("Hello World!");
});

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
          contentType: "application/json",
        },
      }
    );

    console.log(response.data);

    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Server is running on port 3000");
});
