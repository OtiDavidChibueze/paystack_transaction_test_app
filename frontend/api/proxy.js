import fetch from "node-fetch";

export default async function handler(req, res) {
  try {
    // ⚡ Your backend base URL
    const BACKEND_URL = process.env.BACKEND_URL || "http://172.20.10.8:3000";

    // Strip "/api" prefix from the incoming URL
    const url = BACKEND_URL + req.url.replace(/^\/api/, "");

    // Forward request to backend
    const backendResponse = await fetch(url, {
      method: req.method,
      headers: {
        ...req.headers,
        host: new URL(BACKEND_URL).host, // Ensure backend host is correct
      },
      body: req.method !== "GET" ? JSON.stringify(req.body) : undefined,
    });

    // Get backend response as text or JSON
    const contentType = backendResponse.headers.get("content-type");
    const data =
      contentType && contentType.includes("application/json")
        ? await backendResponse.json()
        : await backendResponse.text();

    // Forward response to client
    res.status(backendResponse.status).send(data);
  } catch (err) {
    console.error("Proxy Error:", err);
    res
      .status(500)
      .json({ error: "Proxy request failed", details: err.message });
  }
}
